//
//  PagingCollectionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Parchment
import MBCircularProgressBar

class PagingMainView: UIView {
    
    //MARK: - Outlets -
    @IBOutlet weak var titleCaloriesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activeVIew: UIView!
    @IBOutlet weak var caloriesProgress: MBCircularProgressBarView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var squirrelsLabel: UILabel!
    
    //MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fillView()
    }

    //MARK: - Private -
    private func fillView() {
        fatsLabel.attributedText = fillDescription(title: "Жиры", count: 32)
        carbohydratesLabel.attributedText = fillDescription(title: "Углеводы", count: 0)
        squirrelsLabel.attributedText = fillDescription(title: "Белки", count: 83)
        caloriesLabel.font = caloriesLabel.font?.withSize(isIphone5 ? 12.0 : 14.0)
        
        titleCaloriesLabel.attributedText = getCaloriesTitle(count: "     1350", currency: "+800", wholeSize: 25, сurrencySize: 18, currencyOffset: 20.0)
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    func fillDescription(title: String, count: Int) -> NSMutableAttributedString {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        let fontSize: CGFloat = isIphone5 ? 9.0 : 10.0
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoRegular(size: fontSize),
                                                     color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: title))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: fontSize),
                                                     color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\nОсталось \(count) г"))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        return mutableAttrString
    }
    
//    func getBalance() -> NSMutableAttributedString {
//        if let wallet = UserPrefs.getUser()?.wallet {
//            return wallet.amount.getFormattedBalance(by: wallet, wholeSize: 38.0, fractionalSize: 22.0, сurrencySize: 18.0, baselineOffset: 14.0)
//        } else {
//            return NSMutableAttributedString(string: "")
//        }
//    }
    
    func getCaloriesTitle(count: String,  currency: String, wholeSize: CGFloat, сurrencySize: CGFloat, currencyOffset: CGFloat) -> NSMutableAttributedString {
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: count,
                                                    attributes: setAttributes(size: wholeSize)))
        mutableAttrString.append(NSAttributedString(string: currency, attributes: [.font : UIFont.fontRobotoMedium(size: сurrencySize), .baselineOffset: currencyOffset]))
        
        return mutableAttrString
    }
    
    private func setAttributes(size: CGFloat) -> [NSAttributedString.Key : NSObject] {
        return [NSAttributedString.Key.font: UIFont.fontRobotoMedium(size: size)]
    }
}
