//
//  BasketCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import BEMCheckBox

class BasketCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var checkMark: BEMCheckBox!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCheckMark()
    }
    
    // MARK: - Properties -
    private var delegate: BasketDelegate?
    private var indexPath: IndexPath?
    private var product: SecondProduct?
    
    // MARK: - Interface -
    func fillCell(product: SecondProduct, indexPath: IndexPath, delegate: BasketDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.product = product
        
        fillName(product: product)
        checkMark.setOn(true, animated: false)
        if let calories = product.calories {
            fillCalories(count: calories, product)
        }
    }
    
    // MARK: - Private -
    private func setupCheckMark() {
        checkMark.boxType = .square
    }
    
    private func fillCalories(count: Double, _ product: SecondProduct) { 
        let mutableAttrString = NSMutableAttributedString()
        if let weight = product.weight {
            if let _ = product.portionId {
                if let amount = product.selectedPortion?.amount {
                    let result = Int(count * Double(weight * amount).rounded(toPlaces: 0))
                    let unit = product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT)
                    mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(weight * amount) \(unit) • "))
                    mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(result) \(LS(key: .CALORIES_UNIT))"))
                } else {
                    let result = Int(count * Double(weight).rounded(toPlaces: 1))
                    let unit = product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT)
                    mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(weight) \(unit) • "))
                    mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(result) \(LS(key: .CALORIES_UNIT))"))
                }
            } else {
                let result = Int(count * Double(weight).rounded(toPlaces: 1))
                let unit = product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT)
                mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(weight) \(unit) • "))
                mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(result) \(LS(key: .CALORIES_UNIT))"))
            }
        } else {
            let unit = product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT)
            if let portion = product.selectedPortion {
                let result = Int((count * Double(portion.amount)).rounded(toPlaces: 0))
                mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(portion.amount) \(unit) • "))
                mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(result) \(LS(key: .CALORIES_UNIT))"))
            } else {
                let result = Int(count * Double(100).rounded(toPlaces: 1))
                mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "100 \(unit) • "))
                mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(result) \(LS(key: .CALORIES_UNIT))"))
            }
        }
        caloriesLabel.attributedText = mutableAttrString
    }
    
    private func fillName(product: SecondProduct) { 
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: product.name ?? "", attributes: [.font: UIFont.sfProTextSemibold(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        if let name = product.brand?.name, name != "null" {
            mutableAttrString.append(NSAttributedString(string: " (\(name))", attributes: [.font: UIFont.sfProTextMedium(size: 13), .foregroundColor: #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)]))
        }
        productNameLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text.replacingOccurrences(of: ".0", with: ""), attributes: [.font: UIFont.sfProTextSemibold(size: 11), .foregroundColor: color])
    }
    
    // MARK: - Actions -
    @IBAction func checkMarkClicked(_ sender: Any) {
        guard let product = self.product, let index = self.indexPath else { return }
        checkMark.setOn(!checkMark.on, animated: true)
        self.delegate?.showDeleteAlert(indexPath: index)
    }
}
