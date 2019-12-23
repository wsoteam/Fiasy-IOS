//
//  FavoriteProductVC+KeyboardExtension.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension FavoriteProductViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight + 20
            //reloadBottomView()
            self.tableBottomConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableBottomConstraint.constant = 0
        self.keyboardHeight = 80
        //reloadBottomView()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
