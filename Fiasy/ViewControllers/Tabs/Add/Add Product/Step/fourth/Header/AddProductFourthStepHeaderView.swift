//
//  AddProductFourthStepHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddProductFourthStepHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    static var height: CGFloat = 50.0
    
    // MARK: - Interface -
    func fillHeader(section: Int) {
        let list = UserInfo.sharedInstance.productFlow.allServingSize
        var serving: Serving?
        for item in list where item.selected == true {
            serving = item
            break
        }
        if let ser = serving {
            var nameUnit: String = LS(key: .SECOND_GRAM_UNIT)
            if ser.unitMeasurement == LS(key: .CREATE_STEP_TITLE_19) {
                nameUnit = LS(key: .SECOND_GRAM_UNIT)
            } else if ser.unitMeasurement == LS(key: .CREATE_STEP_TITLE_20) {
                nameUnit = LS(key: .WATER_UNIT)
            } else if ser.unitMeasurement == LS(key: .CREATE_STEP_TITLE_21) {
                nameUnit = LS(key: .LIG_PRODUCT)
            } else if ser.unitMeasurement == LS(key: .CREATE_STEP_TITLE_18) {
                nameUnit = LS(key: .WEIGHT_UNIT)
            }
            titleLabel.text = section == 0 ? LS(key: .PRODUCT_INFO) : "Пищевая ценность на \(ser.servingSize ?? 100) \(nameUnit)"
        } else {
            titleLabel.text = section == 0 ? LS(key: .PRODUCT_INFO) : LS(key: .NUTRITIONAL_VALUE)
        }
    }
    
    func fillRecipeHeader(section: Int) {
        switch section {
        case 0:
            titleLabel.text = LS(key: .RECIPES_INFO)
        case 1:
            titleLabel.text = LS(key: .INGREDIENTS)
        case 2:
            titleLabel.text = LS(key: .INSTRUCTION)
        default:
            break
        }
    }
}
