//
//  PremiumSlideView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumSlideView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var brilliantImageView: UIImageView!
    @IBOutlet weak var amountAfterDiscountLabel: UILabel!
    @IBOutlet weak var crossedOutLabel: UILabel!
    @IBOutlet weak var discountContainerView: UIView!
    @IBOutlet weak var discountPercentLabel: UILabel!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Interface -
    func fillCell(index: Int) {
        switch index {
        case 0:
            brilliantImageView.image = #imageLiteral(resourceName: "brilliant1")
            intervalLabel.text = "1 год"
            discountPercentLabel.text = "SAVE 75%"
            discountContainerView.isHidden = false
            priceLabel.text = "949₽"
            amountAfterDiscountLabel.text = "79,08₽/месяц"
            
            let attributeString = NSMutableAttributedString(string: "316,33₽/месяц")
            attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            crossedOutLabel.attributedText = attributeString
            crossedOutLabel.isHidden = false
        case 1:
            brilliantImageView.image = #imageLiteral(resourceName: "brilliant2")
            intervalLabel.text = "6 месяцев"
            discountPercentLabel.text = "SAVE 27%"
            discountContainerView.isHidden = false
            priceLabel.text = "1450₽"
            amountAfterDiscountLabel.text = "241,67₽/месяц"
            
            let attributeString = NSMutableAttributedString(string: "316,33₽/месяц")
            attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            crossedOutLabel.attributedText = attributeString
            crossedOutLabel.isHidden = false
        case 2:
            brilliantImageView.image = #imageLiteral(resourceName: "brilliant3")
            intervalLabel.text = "3 месяца"
            discountContainerView.isHidden = true
            priceLabel.text = "949₽"
            amountAfterDiscountLabel.text = "316,33₽/месяц"
            crossedOutLabel.isHidden = true
        default:
            break
        }
    }
}
