//
//  InsertPremiumDescriptionView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InsertPremiumDescriptionView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(index: Int, state: PremiumColorState) {
        let color = state == .black ? #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1) : #colorLiteral(red: 0.3568204045, green: 0.3568871021, blue: 0.356816262, alpha: 1)
        topButton.setTitleColor(color, for: .normal)
        bottomLabel.textColor = color
        switch index {
        case 0:
            let image = state == .black ? #imageLiteral(resourceName: "middle_1") : #imageLiteral(resourceName: "prem3")
            topButton.setImage(image, for: .normal)
            topButton.setTitle(" \(LS(key: .LONG_PREM_ARTICLE_TITLE))", for: .normal)
            
            bottomLabel.text = LS(key: .LONG_PREM_ARTICLE_TXT)
        case 1:
            let image = state == .black ? #imageLiteral(resourceName: "middle_2") : #imageLiteral(resourceName: "prem4")
            topButton.setImage(image, for: .normal)
            topButton.setTitle(" \(LS(key: .LONG_PREM_RECIPE_TITLE))", for: .normal)
            
            bottomLabel.text = LS(key: .LONG_PREM_RECIPE_TXT)
        case 2:
            let image = state == .black ? #imageLiteral(resourceName: "middle_3") : #imageLiteral(resourceName: "prem5")
            topButton.setImage(image, for: .normal)
            topButton.setTitle(" \(LS(key: .LONG_PREM_SETTINGS_TITLE))", for: .normal)
            
            bottomLabel.text = LS(key: .LONG_PREM_SETTINGS_TXT)
        case 3:
            let image = state == .black ? #imageLiteral(resourceName: "middle_4") : #imageLiteral(resourceName: "prem6")
            topButton.setImage(image, for: .normal)
            topButton.setTitle(" \(LS(key: .LONG_PREM_PLANS_TITLE))", for: .normal)
            
            bottomLabel.text = LS(key: .LONG_PREM_PLANS_TXT)
        case 4:
            let image = state == .black ? #imageLiteral(resourceName: "middle_5") : #imageLiteral(resourceName: "prem7")
            topButton.setImage(image, for: .normal)
            topButton.setTitle(" \(LS(key: .LONG_PREM_MEASURE_TITLE))", for: .normal)
            
            bottomLabel.text = LS(key: .LONG_PREM_MEASURE_TXT)
        default:
            break
        }
    }
}
