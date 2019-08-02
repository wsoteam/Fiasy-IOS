//
//  AddRecipeVC+KeyboardExtension.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension AddRecipeViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomNextButtonConstraint.constant = (keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)) + 20
            self.tableBottomConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableBottomConstraint.constant = 0
        bottomNextButtonConstraint.constant = 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
