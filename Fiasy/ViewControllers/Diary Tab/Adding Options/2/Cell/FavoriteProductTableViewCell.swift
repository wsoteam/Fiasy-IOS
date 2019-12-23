//
//  FavoriteProductTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import BEMCheckBox

class FavoriteProductTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var checkMark: BEMCheckBox!
    
    // MARK: - Properties -
    private var product: SecondProduct?
    private var delegate: ProductAddingDelegate?
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCheckMark()
    }
    
    // MARK: - Interface -
    func fillCell(product: SecondProduct, delegate: ProductAddingDelegate, _ selectedProduct: [SecondProduct]) {
        self.product = product
        self.delegate = delegate
        
        checkMark.setOn(false, animated: false)
        fillName(product: product)
        if let calories = product.calories {
            fillCalories(count: calories.displayOnly(count: 2), product: product)
        }
        for item in selectedProduct where item.id == product.id {
            checkMark.setOn(true, animated: false)
            break
        }
    }
    
    // MARK: - Private -
    private func setupCheckMark() {
        checkMark.boxType = .square
    }
    
    private func fillCalories(count: Double, product: SecondProduct) { 
        let unit = product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT)
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "100 \(unit) • "))
        mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "\(Double(count * 100).displayOnly(count: 2)) \(LS(key: .CALORIES_UNIT))"))
        caloriesLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text.replacingOccurrences(of: ".0", with: ""), attributes: [.font: UIFont.sfProTextSemibold(size: 11), .foregroundColor: color])
    }
    
    private func fillName(product: SecondProduct) { 
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: product.name ?? "", attributes: [.font: UIFont.sfProTextSemibold(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        if let name = product.brand?.name, name != "null" {
            mutableAttrString.append(NSAttributedString(string: " (\(name))", attributes: [.font: UIFont.sfProTextMedium(size: 13), .foregroundColor: #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)]))
        }
        productNameLabel.attributedText = mutableAttrString
    }
    
    // MARK: - Actions -
    @IBAction func checkMarkClicked(_ sender: Any) {
        guard let product = self.product else { return }
        checkMark.setOn(!checkMark.on, animated: true)
        delegate?.productSelected(product, state: checkMark.on)
    }
}
