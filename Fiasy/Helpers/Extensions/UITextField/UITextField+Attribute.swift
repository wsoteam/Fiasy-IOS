//
//  UITextField+Attribute.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/10/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
