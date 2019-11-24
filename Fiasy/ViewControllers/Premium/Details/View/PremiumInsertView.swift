//
//  PremiumInsertView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/13/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumInsertView: UIView {
    
    // MARK: - Outlet -
    @IBOutlet weak var blackFirstSlideImage: UIImageView!
    @IBOutlet weak var backgroundSlideView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var brilliantImageView: UIImageView!
    @IBOutlet weak var amountAfterDiscountLabel: UILabel!
    @IBOutlet weak var crossedOutLabel: UILabel!
    @IBOutlet weak var discountContainerView: UIView!
    @IBOutlet weak var discountPercentLabel: UILabel!
    
    // MARK: - Properties -
    private var delegate: PremiumDetailsCellDelegate?
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Interface -
    func fillCell(index: Int, state: PremiumColorState, delegate: PremiumDetailsCellDelegate) {
        self.delegate = delegate
        blackFirstSlideImage.isHidden = true
        discountContainerView.backgroundColor = state == .black ? #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        switch index {
        case 0:
            var price1 = "949₽"
            var price2 = "79,08₽"
            var price3 = "316,33₽"
            if Locale.current.languageCode != "ru" {
                price1 = "14.99$"
                price2 = "1.23$"
                price3 = "4.94$"
            }
            tag = 0
            blackFirstSlideImage.isHidden = false
            backgroundSlideView.backgroundColor = state == .black ? .clear : #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            brilliantImageView.image = state == .black ? #imageLiteral(resourceName: "Group 15rrrr8") : #imageLiteral(resourceName: "brilliant1")
            intervalLabel.text = "1 \(LS(key: .YEAR))"
            discountPercentLabel.textColor = state == .black ? #colorLiteral(red: 0.8516539931, green: 0.6581981182, blue: 0.267614007, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let color = state == .black ? #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1) : #colorLiteral(red: 0.3411357403, green: 0.3411998749, blue: 0.3411317468, alpha: 1)
            discountPercentLabel.text = "\(LS(key: .TITLE_SAVE_PERCENT).uppercased()) 75%"
            discountContainerView.isHidden = false
            priceLabel.text = price1
            amountAfterDiscountLabel.text = "\(price2)/\(LS(key: .MONTH))"
            intervalLabel.textColor = color
            priceLabel.textColor = color
            amountAfterDiscountLabel.textColor = color
            crossedOutLabel.textColor = color
            let attributeString = NSMutableAttributedString(string: "\(price3)/\(LS(key: .MONTH))")
            attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            crossedOutLabel.attributedText = attributeString
            crossedOutLabel.isHidden = false
        case 1:
            var price1 = "1450₽"
            var price2 = "241,67₽"
            var price3 = "316,33₽"
            if Locale.current.languageCode != "ru" {
                price1 = "22.75$"
                price2 = "3.76$"
                price3 = "4.94$"
            }
            tag = 1
            backgroundSlideView.backgroundColor = state == .black ? #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1) : #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            brilliantImageView.image = #imageLiteral(resourceName: "brilliant2")
            intervalLabel.text = "6 \(LS(key: .MANY_MOUNTH))"
            discountPercentLabel.textColor = state == .black ? #colorLiteral(red: 0.8516539931, green: 0.6581981182, blue: 0.267614007, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let color = state == .black ? #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1) : #colorLiteral(red: 0.3411357403, green: 0.3411998749, blue: 0.3411317468, alpha: 1)
            discountPercentLabel.text = "\(LS(key: .TITLE_SAVE_PERCENT).uppercased()) 27%"
            discountContainerView.isHidden = false
            priceLabel.text = price1
            amountAfterDiscountLabel.text = "\(price2)/\(LS(key: .MONTH))"
            intervalLabel.textColor = color
            priceLabel.textColor = color
            amountAfterDiscountLabel.textColor = color
            crossedOutLabel.textColor = color
            
            let attributeString = NSMutableAttributedString(string: "\(price3)/\(LS(key: .MONTH))")
            attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            crossedOutLabel.attributedText = attributeString
            crossedOutLabel.isHidden = false
        case 2:
            var price1 = "949₽"
            var price2 = "316,33₽"
            if Locale.current.languageCode != "ru" {
                price1 = "14.99$"
                price2 = "4.94$"
            }
            tag = 2
            let color = #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1)
            backgroundSlideView.backgroundColor = state == .black ? #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1) : #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            brilliantImageView.image = #imageLiteral(resourceName: "brilliant3")
            intervalLabel.textColor = color
            priceLabel.textColor = color
            amountAfterDiscountLabel.textColor = color
            crossedOutLabel.textColor = color
            intervalLabel.text = "3 \(LS(key: .MANY_MOUNTH))"
            discountContainerView.isHidden = true
            priceLabel.text = price1
            amountAfterDiscountLabel.text = "\(price2)/\(LS(key: .MONTH))"
            crossedOutLabel.isHidden = true
        default:
            break
        }
    }
    
    // MARK: - Actions -
    @IBAction func payClicked(_ sender: UIButton) {
        delegate?.pay(by: tag)
    }
    
    //    private func applyColorState(state: PremiumColorState) {
    //        switch state {
    //        case .black:
    //
    //        case .white:
    //            
    //        }
    //    }
}
