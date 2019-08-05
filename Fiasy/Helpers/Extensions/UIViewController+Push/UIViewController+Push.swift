//
//  UIViewController+Push.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/2/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications

extension UIViewController {
    
    func checkIfPushNotificationsEnable(complete: @escaping ((Bool) -> ())) {
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    complete(false)
                // Authorization request has not been made yet
                case .denied:
                    complete(false)
                    // User has denied authorization.
                // You could tell them to change this in Settings
                case .authorized:
                    complete(true)
                    // User has given authorization.
                case .provisional:
                    complete(false)
                }
            })
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                complete(true)
            } else {
                complete(false)
            }
        }
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] (granted, error) in
                
                guard granted else {
                    self?.showPermissionAlert()
                    return
                }
                
                self?.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        //UserDefaults.standard.set(token, forKey: DEVICE_TOKEN)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // If your app was running and in the foreground
        // Or
        // If your app was running or suspended in the background and the user brings it to the foreground by tapping the push notification
        
        print("didReceiveRemoteNotification /(userInfo)")
        
        guard let dict = userInfo["aps"]  as? [String: Any], let msg = dict ["alert"] as? String else {
            print("Notification Parsing Error")
            return
        }
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "Внимание", message: "Пожалуйста, включите доступ к уведомлениям в настройках приложениия.", preferredStyle: .alert)
        
        alert.setValue(NSAttributedString(string: alert.title ?? "", attributes: [.font : UIFont.sfProTextSemibold(size: 17), .foregroundColor : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [.font : UIFont.sfProTextRegular(size: 13), .foregroundColor : #colorLiteral(red: 0.3803474307, green: 0.3804178834, blue: 0.38034302, alpha: 1)]), forKey: "attributedMessage")
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }
        
        settingsAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        cancelAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func gotoAppSettings() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
}
