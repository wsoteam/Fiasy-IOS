//
//  DiaryTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryTableViewCell: SwipeTableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var caloriesCountLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productWeight: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Interface -
    func fillCell(mealTime: Mealtime, isContainNext: Bool) {
        productNameLabel.text = mealTime.name
        var portionSize: Int?
        if let id = mealTime.portionId, !mealTime.measurementUnits.isEmpty {
            for item in mealTime.measurementUnits where item.id == id {
                portionSize = item.amount
                break
            }
        }
        
        if let weight = mealTime.weight, let calories =  mealTime.calories {
            if let size = portionSize {
                caloriesCountLabel.text = "\(Int(calories * Double(weight * size).rounded(toPlaces: 0))) Ккал"
            } else {
                let size = calories * Double(weight)
                caloriesCountLabel.text = "\(Int(size.rounded(toPlaces: 0))) Ккал" 
            }
        } else {
            caloriesCountLabel.text = "\(mealTime.calories ?? 0) Ккал"
        }
        
        if let brand = mealTime.brand, !brand.isEmpty {
            if let finded = portionSize {
                let size = Int(Double((mealTime.weight ?? 0) * finded).displayOnly(count: 0))
                productWeight.text = "\(brand) • \(size) \(mealTime.isLiquid == true ? "мл" : "г")."
            } else {
                productWeight.text = "\(mealTime.weight ?? 0) \(mealTime.isLiquid == true ? "мл" : "г")."
            }
        } else {
            if let finded = portionSize {
                let size = Int(Double((mealTime.weight ?? 0) * finded).displayOnly(count: 0))
                productWeight.text = "\(size) \(mealTime.isLiquid == true ? "мл" : "г")."
            } else {
                productWeight.text = "\(mealTime.weight ?? 0) \(mealTime.isLiquid == true ? "мл" : "г")."
            }
        }
    }
}
