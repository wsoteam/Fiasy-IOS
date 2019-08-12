//
//  SubscriptionService.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import StoreKit
import Alamofire
import Amplitude_iOS
import Intercom

enum ReceiptValidationError: Error {
    case receiptNotFound
    case jsonResponseIsNotValid(description: String)
    case notBought
    case expired
}

class SubscriptionService: NSObject {
    
    static let shared = SubscriptionService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products: Set = ["com.fiasy.fiasyappAutoRenewableSubscriptions"]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
        
        UserInfo.sharedInstance.purchaseIsValid = checkValidPurchases()
    }
    
    func purchase() {
        guard let productToPurchase = products.first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func checkValidPurchases() -> Bool {
        do {
            try validateReceipt()
            print("Receipt is valid")
            return true
        } catch ReceiptValidationError.receiptNotFound {
            // There is no receipt on the device
            print("There is no receipt on the device")
            return false
        } catch ReceiptValidationError.jsonResponseIsNotValid(let description) {
            // unable to parse the json
            print(description)
            return false
        } catch ReceiptValidationError.notBought {
            // the subscription hasn't being purchased
            print("the subscription hasn't being purchased")
            return false
        } catch ReceiptValidationError.expired {
            print("the subscription is expired")
            return false
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    }
    
    //MARK: - Receipt Validation -
    func validateReceipt() throws {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            throw ReceiptValidationError.receiptNotFound
        }
        
        let receiptData = try! Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
        let receiptString = receiptData.base64EncodedString()
        let jsonObjectBody = ["receipt-data" : receiptString, "password" : "01ef8ea9c82046578c8e45b953c95652"]
        
        #if DEBUG
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        #else
        let url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
        #endif
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObjectBody, options: .prettyPrinted)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var validationError : ReceiptValidationError?
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200 else {
                validationError = ReceiptValidationError.jsonResponseIsNotValid(description: error?.localizedDescription ?? "")
                semaphore.signal()
                return
            }
            guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else {
                validationError = ReceiptValidationError.jsonResponseIsNotValid(description: "Unable to parse json")
                semaphore.signal()
                return
            }
            guard let expirationDate = self.expirationDate(jsonResponse: jsonResponse, forProductId: "com.fiasy.fiasyappAutoRenewableSubscriptions") else {
                validationError = ReceiptValidationError.notBought
                semaphore.signal()
                return
            }
            
            let currentDate = Date()
            if currentDate > expirationDate {
                validationError = ReceiptValidationError.expired
            }
            semaphore.signal()
        }
        task.resume()
        
        semaphore.wait()
        
        if let validationError = validationError {
            throw validationError
        }
    }
    
    func expirationDate(jsonResponse: [AnyHashable: Any], forProductId productId :String) -> Date? {
        guard let receiptInfo = (jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]]) else {
            return nil
        }
        
        let filteredReceipts = receiptInfo.filter{ return ($0["product_id"] as? String) == productId }
        
        guard let lastReceipt = filteredReceipts.last else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        
        if let expiresString = lastReceipt["expires_date"] as? String {
            return formatter.date(from: expiresString)
        }
        
        return nil
    }
}

extension SubscriptionService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
}

extension SubscriptionService: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue,
                             updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        Intercom.logEvent(withName: "purchase_success")
        Amplitude.instance()?.logEvent("purchase_success")
        NotificationCenter.default.post(name: Notification.Name("PaymentComplete"), object: nil)
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        
        guard let productToPurchase = products.first else { return }
        Intercom.logEvent(withName: "revenue", metaData: ["quantuty" : productToPurchase.price])
        Amplitude.instance()?.logEvent("revenue", withEventProperties: ["quantuty" : productToPurchase.price])
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            
            Intercom.logEvent(withName: "purchase_error", metaData: ["purchase_error" : localizedDescription])
            Amplitude.instance()?.logEvent("question_error", withEventProperties: ["purchase_error" : localizedDescription])
            print("Transaction Error: \(localizedDescription)")
        }
        Intercom.logEvent(withName: "trial_error")
        Amplitude.instance()?.logEvent("trial_error")
    
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }

//        UserDefaults.standard.set(true, forKey: identifier)
//        UserDefaults.standard.synchronize()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: ""), object: identifier)
    }
}

