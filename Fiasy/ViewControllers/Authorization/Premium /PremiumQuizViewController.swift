//
//  PremiumQuizViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Intercom
import Amplitude_iOS

class PremiumQuizViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Properties -
    var isAutorization: Bool = true
    var trialFrom: String = "onboarding"
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.isHidden = !isAutorization
        
        var bottomPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        }
        if bottomPadding > 0.0 {
            topConstraint.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(paymentComplete), Constant.PAYMENT_COMPLETE)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @objc func paymentComplete() {
        UserInfo.sharedInstance.paymentComplete = true
        DispatchQueue.global().async {
            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
        }
        performSegue(withIdentifier: "sequeFinishPremiumScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumFinishViewController {
            let vc = segue.destination as? PremiumFinishViewController
            vc?.isAutorization = self.isAutorization
        }
    }
    
    // MARK: - Action's -
    @IBAction func showPrivacyClicked(_ sender: Any) {
        Intercom.logEvent(withName: "premium_next", metaData: ["push_button" : "privacy"]) // +
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "privacy"]) // +
        if let url = URL(string: "http://fiasy.com/PrivacyPolice.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        Intercom.logEvent(withName: "onboarding_success", metaData: ["from" : "close"]) // +
        Amplitude.instance()?.logEvent("onboarding_success", withEventProperties: ["from" : "close"]) // +
        
        let identify = AMPIdentify()
        identify.set("premium_status", value: "free" as NSObject)
        Amplitude.instance()?.identify(identify)
        
        let attributed = ICMUserAttributes()
        attributed.customAttributes = ["premium_status": "free"]
        Intercom.updateUser(attributed)
        
        Intercom.logEvent(withName: "premium_next", metaData: ["push_button" : "close"]) // +
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "close"]) // +
        performSegue(withIdentifier: "sequeMenuScreen", sender: nil)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        Intercom.logEvent(withName: "premium_next", metaData: ["push_button" : "back"]) // +
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "back"]) // +
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func purchedClicked(_ sender: Any) {
        UserInfo.sharedInstance.trialFrom = trialFrom
        Intercom.logEvent(withName: "premium_next", metaData: ["push_button" : "next"]) // +
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "next"]) // +
        SubscriptionService.shared.purchase()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
        guard scrollView.contentOffset.y > 0 else {
            return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
    }
}
