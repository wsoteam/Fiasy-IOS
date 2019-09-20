//
//  ErrorViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import VisualEffectView
import NextGrowingTextView
import Intercom
import Amplitude_iOS

class ErrorViewController: UIViewController {
    
    // MARK: - Outlet's -
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sendTextView: NextGrowingTextView!
    @IBOutlet weak var blurView: VisualEffectView!
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Amplitude.instance().logEvent("product_page_bugsend") // +
        Intercom.logEvent(withName: "product_page_bugsend") // +
        setupInitialState()
        sendTextView.configureGrowingTextView()
        sendTextView.textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showAnimate()
    }
    
    // MARK: - Privates -
    private func setupInitialState() {
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1

        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
    }
    
    private func sendClaims() {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid, let product = UserInfo.sharedInstance.selectedProduct {
            let calendar = Calendar.current
            let currentDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: Date())!
            let currentMonth = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: Date())!
            let currentYear = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: Date())!
            
            let hour = calendar.component(.hour, from: Date())
            let minutes = calendar.component(.minute, from: Date())
            
            let userData = ["day": currentDay, "month": currentMonth, "year": currentYear, "hours": hour, "minutes": minutes, "userId" : uid, "foodInfo" : "\(product.name ?? "") (\(product.brend ?? ""))", "foodId" : product.id, "textClaim" : sendTextView.textView.text] as [String : Any]
            ref.child("CLAIMS").childByAutoId().setValue(userData)
        }
    }
    
    private func showAnimate() {
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0.0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.alpha = 1.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self?.sendTextView.textView.becomeFirstResponder()
        }
    }
    
    private func removeAnimate() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.containerView.alpha = 0.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {[weak self] _ in
                self?.dismiss(animated: true)
        })
    }
    
    // MARK: - Actions -
    @IBAction func closeScreen(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        messageStackView.isHidden = true
        progressContainerView.isHidden = false
        closeButton.isHidden = true
        progressView.setProgressWithAnimation(duration: 1, value: 1) { [weak self] in
            self?.sendClaims()
            self?.removeAnimate()
        }
    }
}

extension ErrorViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let message = textView.text else { return }
        
        if message.replacingOccurrences(of: " ", with: "").count >= 10 {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
        }
    }
}
