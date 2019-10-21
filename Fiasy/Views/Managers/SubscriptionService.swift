//
//  SubscriptionService.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Adjust
import StoreKit
import Alamofire
import FacebookCore
import Amplitude_iOS
import FBSDKCoreKit
import Firebase
import FirebaseStorage

enum ReceiptValidationError: Error {
    case receiptNotFound
    case jsonResponseIsNotValid(description: String)
    case notBought
    case expired
}

class SubscriptionService: NSObject {
    
    static let shared = SubscriptionService()
    
    var price: NSDecimalNumber = 0.0
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products: Set = ["com.fiasy.NewAutoYearlySubscriptions", "com.fiasy.NewAutoHalfYearSubscriptions", "com.fiasy.NewAutoThreeMonthsSubscriptions"]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(index: Int) {
        let allSubscription = ["com.fiasy.NewAutoYearlySubscriptions", "com.fiasy.NewAutoHalfYearSubscriptions", "com.fiasy.NewAutoThreeMonthsSubscriptions"]
        
        if allSubscription.indices.contains(index) {
            var product: SKProduct?
            for item in products where item.productIdentifier == allSubscription[index] {
                product = item
                break
            }
            if let productToPurchase = product {
                let payment = SKPayment(product: productToPurchase)
                price = productToPurchase.price
                paymentQueue.add(payment)
            }
        }
    }
    
    func localizedPriceForProduct(_ product:SKProduct) -> String {
        let priceFormatter = NumberFormatter()
        priceFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        priceFormatter.numberStyle = NumberFormatter.Style.currency
        priceFormatter.locale = product.priceLocale
        return priceFormatter.string(from: product.price)!
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func checkValidPurchases(generalState: Bool) {
         checkSubscription(generalState)
//        do {
//            try checkSubscription(generalState)
//            print("Receipt is valid")
//            return true
//        } catch ReceiptValidationError.receiptNotFound {
//            // There is no receipt on the device
//            print("There is no receipt on the device")
//            return false
//        } catch ReceiptValidationError.jsonResponseIsNotValid(let description) {
//            // unable to parse the json
//            print(description)
//            return false
//        } catch ReceiptValidationError.notBought {
//            // the subscription hasn't being purchased
//            print("the subscription hasn't being purchased")
//            return false
//        } catch ReceiptValidationError.expired {
//            print("the subscription is expired")
//            return false
//        } catch {
//            print("Unexpected error: \(error).")
//            return false
//        }
    }
    
    //MARK: - Receipt Validation -
    func checkSubscription(_ generalState: Bool) {
        
        let semaphore = DispatchSemaphore(value: 0)
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            let receiptData = try! Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
            let receiptString = receiptData.base64EncodedString()
            
            if let uid = Auth.auth().currentUser?.uid {
                //let userData = ["appStoreReceipt": receiptString] as [String : Any]
                Database.database().reference().child("USER_LIST").child(uid).child("profile").child("appStoreReceipt").setValue(receiptString)
            }
            
            let jsonObjectBody = ["receipt-data" : receiptString, "password" : "01ef8ea9c82046578c8e45b953c95652"]
            
            #if DEBUG
            let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
            #else
            let url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
            #endif

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObjectBody, options: .prettyPrinted)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200 else {
                    UserInfo.sharedInstance.purchaseIsValid = false
                    return
                }
                guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else {
                    UserInfo.sharedInstance.purchaseIsValid = false
                    return
                }
                
                if let dictionary = jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]], let first = dictionary.first, let state = first["is_trial_period"] {
                    if self.getBoolFromAny(paramAny: state) {
                        let identify = AMPIdentify()
                        identify.set("premium_status", value: "trial" as NSObject)
                        Amplitude.instance()?.identify(identify)
                        AppEventsLogger.log(FBSDKAppEventNameStartTrial)
                        
                        //
                        Adjust.trackEvent(ADJEvent.init(eventToken: "wxd2a7"))
                        //
                        if UserInfo.sharedInstance.trialFrom == "onboarding" {
                            Amplitude.instance()?.logEvent("onboarding_success", withEventProperties: ["from" : "trial"]) // +
                        }
                        
                        if generalState {
                            Amplitude.instance()?.logEvent("trial_success", withEventProperties: ["trial_from" : UserInfo.sharedInstance.trialFrom]) // +
                        }
                    } else {
                        let identify = AMPIdentify()
                        identify.set("premium_status", value: "premium" as NSObject)
                        Amplitude.instance()?.identify(identify)
                        
                        if generalState {
                            Amplitude.instance()?.logEvent("purchase_success") // +
                            
                            if Double(self.price) > 0.0 {
                                FBSDKAppEvents.logPurchase(Double(self.price), currency: "RUB")
                                let event = ADJEvent.init(eventToken: "xrf3ix")
                                event?.setRevenue(Double(self.price), currency: "RUB")
                                Adjust.trackEvent(event)
                                
                                Amplitude.instance()?.logRevenue(self.price)
                            }
                        }
                    }
                }
                
                guard let expirationDate = self.expirationDate(jsonResponse: jsonResponse) else {
                    UserInfo.sharedInstance.purchaseIsValid = false
                    return
                }
                
                if Date() > expirationDate {
                    UserInfo.sharedInstance.purchaseIsValid = false
                } else {
                    UserInfo.sharedInstance.purchaseIsValid = true
                }
                semaphore.signal()
            }
            task.resume()
            
            semaphore.wait()
        } else {
            getCurrentUserRecipe(generalState: generalState)
        }
    }
    
    private func getCurrentUserRecipe(generalState: Bool) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("profile").child("appStoreReceipt").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? String {
                    let jsonObjectBody = ["receipt-data" : snapshotValue, "password" : "01ef8ea9c82046578c8e45b953c95652"]
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
                            UserInfo.sharedInstance.purchaseIsValid = false
                            return
                        }
                        guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else {
                            UserInfo.sharedInstance.purchaseIsValid = false
                            return
                        }
                        
                        if let dictionary = jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]], let first = dictionary.first, let state = first["is_trial_period"] {
                            if self.getBoolFromAny(paramAny: state) {
                                let identify = AMPIdentify()
                                identify.set("premium_status", value: "trial" as NSObject)
                                Amplitude.instance()?.identify(identify)
                                AppEventsLogger.log(FBSDKAppEventNameStartTrial)
                                
                                //
                                Adjust.trackEvent(ADJEvent.init(eventToken: "wxd2a7"))
                                //
                                if UserInfo.sharedInstance.trialFrom == "onboarding" {
                                    Amplitude.instance()?.logEvent("onboarding_success", withEventProperties: ["from" : "trial"]) // +
                                }
                                
                                if generalState {
                                    Amplitude.instance()?.logEvent("trial_success", withEventProperties: ["trial_from" : UserInfo.sharedInstance.trialFrom]) // +
                                }
                            } else {
                                let identify = AMPIdentify()
                                identify.set("premium_status", value: "premium" as NSObject)
                                Amplitude.instance()?.identify(identify)
                                
                                if generalState {
                                    Amplitude.instance()?.logEvent("purchase_success") // +
                                    
                                    if Double(self.price) > 0.0 {
                                        FBSDKAppEvents.logPurchase(Double(self.price), currency: "RUB")
                                        let event = ADJEvent.init(eventToken: "xrf3ix")
                                        event?.setRevenue(Double(self.price), currency: "RUB")
                                        Adjust.trackEvent(event)
                                        
                                        Amplitude.instance()?.logRevenue(self.price)
                                    }
                                }
                            }
                        }
                        
                        guard let expirationDate = self.expirationDate(jsonResponse: jsonResponse) else {
                            UserInfo.sharedInstance.purchaseIsValid = false
                            return
                        }
                        
                        if Date() > expirationDate {
                            UserInfo.sharedInstance.purchaseIsValid = false
                        } else {
                            UserInfo.sharedInstance.purchaseIsValid = true
                        }
                        semaphore.signal()
                    }
                    task.resume()
                    
                    semaphore.wait()
                }
            }) { (error) in
                UserInfo.sharedInstance.purchaseIsValid = false
            }
        } else {
            UserInfo.sharedInstance.purchaseIsValid = false
        }
    }

    private func getBoolFromAny(paramAny: Any) -> Bool {
        let str = "\(paramAny)"
        return str == "true"
    }
    
    func expirationDate(jsonResponse: [AnyHashable: Any]) -> Date? {
        guard let receiptInfo = (jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]]) else {
            return nil
        }
        
        guard let lastReceipt = receiptInfo.last else {
            return nil
        }
        if let expiresString = lastReceipt["expires_date_ms"] as? String, let second = Int64(expiresString) {
            return expiresString.dateFromMilliseconds(second: second)
        }
        return nil
    }
}

extension String {
    func dateFromMilliseconds(second: Int64) -> Date {
        let date = Date(milliseconds: second)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStamp = dateFormatter.string(from: date as Date)
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date( from: timeStamp ) ?? Date()
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
        
        let identify = AMPIdentify()
        if let day = Calendar.current.dateComponents([.day], from: Date()).day {
            identify.set("first_day", value: day as NSObject)
        }
        if let week = Calendar.current.dateComponents([.weekOfMonth], from: Date()).weekOfMonth {
            identify.set("first_week", value: week as NSObject)
        }
        if let month = Calendar.current.dateComponents([.month], from: Date()).month {
            identify.set("first_month", value: month as NSObject)
        }
        Amplitude.instance()?.identify(identify)
        
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        
//        guard let productToPurchase = products.first else { return }
//        Amplitude.instance()?.logEvent("revenue", withEventProperties: ["quantuty" : productToPurchase.price])
        
//        let event = ADJEvent.init(eventToken: "xrf3ix")
//        event?.setRevenue(Double(productToPurchase.price), currency: "RUB")
//        Adjust.trackEvent(event)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError? {
            
            switch transactionError.code {
            case SKError.paymentCancelled.rawValue:
                Amplitude.instance()?.logEvent("trial_error", withEventProperties: ["back_or_canceled" : transaction.error?.localizedDescription])
            case SKError.paymentInvalid.rawValue:
                Amplitude.instance()?.logEvent("trial_error", withEventProperties: ["item_unvailable" : transaction.error?.localizedDescription])
            case SKError.paymentNotAllowed.rawValue:
                Amplitude.instance()?.logEvent("trial_error", withEventProperties: ["billing_unvailable" : transaction.error?.localizedDescription])
            case SKError.clientInvalid.rawValue:
                Amplitude.instance()?.logEvent("trial_error", withEventProperties: ["service_unvailable" : transaction.error?.localizedDescription])
            default:
                Amplitude.instance()?.logEvent("trial_error", withEventProperties: ["error" : transaction.error?.localizedDescription])
            }
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        NotificationCenter.default.post(name: Notification.Name("PaymentComplete"), object: nil)
    }
}

