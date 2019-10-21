//
//  PromotionalCodeVC+KeyboardExtension.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension PromotionalCodeViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.writeCodeContainerView.isHidden = false
            self.bottomCodeConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.bottomCodeConstraint.constant = 0
        self.writeCodeContainerView.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
