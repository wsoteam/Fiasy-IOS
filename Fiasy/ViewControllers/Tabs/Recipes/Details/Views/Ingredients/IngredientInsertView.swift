//
//  IngredientInsertView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class IngredientInsertView: UIView {
    
    //MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Interface -
    func fillView(_ ingredient: String, count: Int) {
        let mutableAttrString = NSMutableAttributedString()
//        
//        let name = "\(ingredient[0])".replacingOccurrences(of: "string(\"", with: "").replacingOccurrences(of: "\")", with: "")
//        let double = "\(ingredient[1])".replacingOccurrences(of: "double(", with: "").replacingOccurrences(of: ")", with: "")
//        let until = "\(ingredient[2])".replacingOccurrences(of: "string(\"", with: "").replacingOccurrences(of: "\")", with: "")

        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 15.0),
                                                     color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: ingredient))
//        if let doubl = Double(double) {
//            mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 15.0),
//                            color: #colorLiteral(red: 0.4666130543, green: 0.4666974545, blue: 0.4666077495, alpha: 1), text: " (\(Double(count) * doubl) \(until))"))
//        }
        titleLabel.attributedText = mutableAttrString
    }
    
    func fillOwnRecipeView(product: Product, count: Int) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 15.0),
                                                     color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: product.name ?? ""))
        if let productWeight = product.productWeightByAdd {
            mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 15.0),
                                                         color: #colorLiteral(red: 0.4666130543, green: 0.4666974545, blue: 0.4666077495, alpha: 1), text: " (\(count * productWeight) г)"))
        }
        titleLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
}
