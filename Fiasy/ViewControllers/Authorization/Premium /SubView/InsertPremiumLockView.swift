//
//  InsertPremiumLockView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InsertPremiumLockView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    // MARK: - Interface -
    func fillView(index: Int, state: PremiumColorState) {
        rightImage.image = state == .black ? #imageLiteral(resourceName: "checkmark_black") : #imageLiteral(resourceName: "Shape (4)")
        titleLabel.textColor = state == .black ? #colorLiteral(red: 0.8744148612, green: 0.8744921684, blue: 0.8785049319, alpha: 1) : #colorLiteral(red: 0.3568198979, green: 0.3569589853, blue: 0.3527144492, alpha: 1)
        leftImage.image = #imageLiteral(resourceName: "lock_icon")
        switch index {
        case 0:
            titleLabel.text = LS(key: .LONG_PREM_FEATURES_DIARY)
            leftImage.image = state == .black ? #imageLiteral(resourceName: "checkmark_black") : #imageLiteral(resourceName: "Shape (4)")
            backgroundImageView.backgroundColor = state == .black ? #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1) : #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        case 1:
            titleLabel.text = LS(key: .LONG_PREM_FEATURES_ELEMENTS)
            backgroundImageView.backgroundColor = state == .black ? #colorLiteral(red: 0.1019451842, green: 0.1018963829, blue: 0.1060404405, alpha: 1) : #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        case 2:
            titleLabel.text = LS(key: .LONG_PREM_FEATURES_RECIPE)
            backgroundImageView.backgroundColor = state == .black ? #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1) : #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        case 3:
            titleLabel.text = LS(key: .LONG_PREM_FEATURES_ARTICLES)
            backgroundImageView.backgroundColor = state == .black ? #colorLiteral(red: 0.1019451842, green: 0.1018963829, blue: 0.1060404405, alpha: 1) : #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        case 4:
            titleLabel.text = LS(key: .LONG_PREM_PLANS_TITLE)
            backgroundImageView.backgroundColor = state == .black ? #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1) : #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        case 5:
            titleLabel.text = LS(key: .LONG_PREM_FEATURES_STATISTIC)
            backgroundImageView.backgroundColor = state == .black ? #colorLiteral(red: 0.1019451842, green: 0.1018963829, blue: 0.1060404405, alpha: 1) : #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        case 6:
            titleLabel.text = LS(key: .LONG_PREM_FEATURES_BODY)
            backgroundImageView.backgroundColor = state == .black ? #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1) : #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        default:
            break
        }
    }
}
