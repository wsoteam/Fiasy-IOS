//
//  CalorieIntakeHeaderView.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 9/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class CalorieIntakeHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    static var height: CGFloat = 120.0
    
    // MARK: - Interface -
    func fillHeader(_ purchaseIsValid: Bool) {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                     color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "Задать свою норму КБЖУ"))
        if !purchaseIsValid {
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextRegular(size: 12),
                                                         color: #colorLiteral(red: 0.6430656314, green: 0.6431785822, blue: 0.6430584788, alpha: 1), text: "\nЧтобы изменить КБЖУ вы должны купить"))
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 12),
                                                         color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: " PREMIUM"))
            mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
            
            titleLabel.attributedText = mutableAttrString
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(CalorieIntakeHeaderView.tapFunction))
            titleLabel.isUserInteractionEnabled = true
            titleLabel.addGestureRecognizer(tap)
        } else {
            titleLabel.attributedText = mutableAttrString
        }
    }
    
    // MARK: - Private -
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    // MARK: - Actions -
    @objc func tapFunction(gesture: UITapGestureRecognizer) {
        let text = (titleLabel.text)!
        let termsRange = (text as NSString).range(of: "PREMIUM")
        if gesture.didTapAttributedTextInLabel(label: titleLabel, inRange: termsRange) {
            if let vc = UIApplication.getTopMostViewController() as? CalorieIntakeViewController {
                vc.performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
            }
        }
    }
}
