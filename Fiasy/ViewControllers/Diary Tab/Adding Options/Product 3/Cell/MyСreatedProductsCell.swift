//
//  MyСreatedProductsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown

class MyСreatedProductsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    private var dropDown = DropDown()
    private var removeKey: String?
    private var delegate: MyСreatedProductsDelegate?
    
    // MARK: - Interface -
    func fillCell(_ item: Favorite, delegate: MyСreatedProductsDelegate, indexPath: IndexPath) {
        fillDropDown()
        self.removeKey = item.key
        self.delegate = delegate
        nameLabel.text = item.name
        
        if item.measurementUnits.isEmpty {
            countLabel.text = "\(Int(Double(Double(item.calories ?? 0.0) * 100).displayOnly(count: 0))) \(LS(key: .CALORIES_UNIT)) • 100 \(item.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
        } else {
            if let first = item.measurementUnits.first {
                var nameUnit: String = LS(key: .SECOND_GRAM_UNIT)
                if first.unit == LS(key: .CREATE_STEP_TITLE_19) {
                    nameUnit = LS(key: .SECOND_GRAM_UNIT)
                } else if first.unit == LS(key: .CREATE_STEP_TITLE_20) {
                    nameUnit = LS(key: .WATER_UNIT)
                } else if first.unit == LS(key: .CREATE_STEP_TITLE_21) {
                    nameUnit = LS(key: .LIG_PRODUCT)
                } else if first.unit == LS(key: .CREATE_STEP_TITLE_18) {
                    nameUnit = LS(key: .WEIGHT_UNIT)
                }
                countLabel.text = "\(Double(item.calories ?? 0.0).displayOnly(count: 1)) \(LS(key: .CALORIES_UNIT)) • \(first.amount) \(nameUnit)".replacingOccurrences(of: ".0", with: "")
            }
        }
    }
    
    //MARK: - Private -
    private func fillDropDown() {
        DropDown.appearance().IBcornerRadius = 10
        DropDown.appearance().textFont = UIFont.sfProTextMedium(size: 15)
        if dropDown.dataSource.isEmpty {
            dropDown.dataSource.append("     \(LS(key: .CREATE_STEP_TITLE_36))")
            dropDown.dataSource.append("     \(LS(key: .DELETE))")
        }
        
        dropDown.anchorView = containerView
        dropDown.textColor = #colorLiteral(red: 0.2431066334, green: 0.2431548834, blue: 0.2431036532, alpha: 1)
        dropDown.selectedTextColor = #colorLiteral(red: 0.2431066334, green: 0.2431548834, blue: 0.2431036532, alpha: 1)
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        dropDown.shadowColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 0.7022146451)
        DropDown.appearance().cellHeight = 50
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)

        dropDown.cornerRadius = 8.0
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self, let key = strongSelf.removeKey else { return }
            switch index {
            case 0:
                strongSelf.delegate?.editProduct(key)
            case 1:
                strongSelf.delegate?.removeProduct(key)
            default:
                break
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func dotsClicked(_ sender: Any) {
        dropDown.show()
    }
}
