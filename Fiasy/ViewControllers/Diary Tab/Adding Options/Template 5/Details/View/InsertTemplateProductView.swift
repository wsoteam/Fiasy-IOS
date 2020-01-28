//
//  InsertTemplateProductView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InsertTemplateProductView: UIView {
    
    // MARK: - Outlet -
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var productCountLabel: UILabel!
    
    // MARK: - Interface -
    func fillView(_ first: Bool, _ product: SecondProduct, _ allCount: Int) {
        topContainerView.isHidden = !first
        topSeparatorView.isHidden = first
        
        productCountLabel.text = "\(allCount) \(fetchCountPrefix(count: allCount))"
        
        if let calories = product.calories {
            var size: Double = calories * 100.0
            if let weg = product.weight {
                size = calories * Double(weg)
            }
            caloriesLabel.text = "\(Int(size.rounded(toPlaces: 0))) \(LS(key: .CALORIES_UNIT).capitalizeFirst)"
        } else {
            caloriesLabel.text = "\(product.calories ?? 0) \(LS(key: .CALORIES_UNIT).capitalizeFirst)"
        }
        if let brand = product.brend, brand != "null" && !brand.isEmpty {
            var size: Int = 100
            if let weg = product.weight {
                size = weg
            }
            weightLabel.text = "\(brand) • \(size) \(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
        } else {
            if let brend = product.brand?.name {
                var size: Int = 100
                if let weg = product.weight {
                    size = weg
                }
                weightLabel.text = "\(brend) • \(size) \(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
            } else {
                var size: Int = 100
                if let weg = product.weight {
                    size = weg
                }
                weightLabel.text = "\(size) \(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
            }
        }
        nameLabel.text = product.name
    }
    
    // MARK: - Private -
    private func fetchCountPrefix(count: Int) -> String {
        if getPreferredLocale().languageCode == "ru" {
            
            switch count {
            case 1:
                return "продукт"
            case 2,3,4:
                return "продукта"
            default:
                return "продуктов"
            }
        } else {
            return LS(key: .COUNT_PRODUCTS)
        }
    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
