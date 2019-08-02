//
//  NotificationManage.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol NotificationManage {
    func addObserver(for vc: UIViewController, _ sel: Selector, _ name: String)
    func post(_ notification: String, with data: Data?)
    func removeObserver()
}

extension NotificationManage {
    func post(_ notification: String, with data: Data? = nil) {
        post(notification, with: data)
    }
}

extension UIViewController: NotificationManage {
    func addObserver(for vc: UIViewController, _ sel: Selector, _ name: String) {
        NotificationCenter.default.addObserver(vc, selector: sel, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func post(_ notification: String, with data: Data? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: notification), object: data)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func removeObserver(by name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
}
