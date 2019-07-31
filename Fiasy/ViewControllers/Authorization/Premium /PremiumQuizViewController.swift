//
//  PremiumQuizViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Amplitude_iOS

class PremiumQuizViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(paymentComplete), Constant.PAYMENT_COMPLETE)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    @objc func paymentComplete() {
        UserInfo.sharedInstance.paymentComplete = true
        DispatchQueue.global().async {
            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
        }
        performSegue(withIdentifier: "sequeMenuScreen", sender: nil)
    }
    
    // MARK: - Action's -
    @IBAction func showPrivacyClicked(_ sender: Any) {
        if let url = URL(string: "http://fiasy.com/PrivacyPolice.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("close_premium")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func purchedClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("click_on_buy")
        SubscriptionService.shared.purchase()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 else {
            return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
    }
}
