//
//  NotificationsAlertViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import OneSignal
import VisualEffectView
import UserNotifications

class NotificationsAlertViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    var completionHandler: (() -> Void)?
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Interface -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showAnimate()
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        if isIphone5 {
            messageLabel.font = messageLabel.font.withSize(12)
            titleLabel.font = titleLabel.font.withSize(18)
        }
        blurView.colorTint = .black
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
    }
    
    private func showAnimate() {
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0.0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.alpha = 1.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
    
    private func removeSomeAnimate() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.containerView.alpha = 0.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {[weak self] _ in
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.completionHandler?()
                })
        })
    }
    
    // MARK: - Actions -
    @IBAction func closeModuleClicked(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func notificationClicked(_ sender: Any) {
//        removeSomeAnimate()
        
//        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
//        
//        OneSignal.initWithLaunchOptions(launchOptions,
//                                        appId: "9fda9c37-f81a-4fc2-b4a9-b6b5084445e7",
//                                        handleNotificationAction: nil,
//                                        settings: onesignalInitSettings)
        
//        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
//        OneSignal.promptForPushNotifications(userResponse: { accepted in
//            print("User accepted notifications: \(accepted)")
//        })
    }
}
