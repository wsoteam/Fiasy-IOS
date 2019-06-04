//
//  UIButton+NSMutableAttributedString.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    @discardableResult func underline(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left
        let attrs : [NSAttributedString.Key : Any] = [
            .font : UIFont.fontRobotoLight(size: fontSize),
            .foregroundColor : #colorLiteral(red: 0.4472076893, green: 0.400949955, blue: 0.3248954713, alpha: 1),
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .paragraphStyle: titleParagraphStyle]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func light(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left
        let attrs : [NSAttributedString.Key : Any] = [
            .font :  UIFont.fontRobotoLight(size: fontSize),
            .foregroundColor : #colorLiteral(red: 0.4472076893, green: 0.400949955, blue: 0.3248954713, alpha: 1),
            .paragraphStyle: titleParagraphStyle
        ]
    
        let normal =  NSAttributedString(string: text,  attributes:attrs)
        self.append(normal)
        return self
    }
}

extension UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.alpha = self.isHighlighted ? 0.8 : 1.0
            }
        }
    }
}
