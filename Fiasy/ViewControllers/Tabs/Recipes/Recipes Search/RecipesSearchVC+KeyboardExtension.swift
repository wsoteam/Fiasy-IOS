//
//  RecipesSearchVC+KeyboardExtension.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension RecipesSearchViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.bottomTableConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.bottomTableConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
