//
//  DiaryFooterView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryFooterView: UITableViewHeaderFooterView {

    // MARK: - Outlet -
    @IBOutlet weak var carbohydratesCount: UILabel!
    @IBOutlet weak var caloriesCount: UILabel!
    @IBOutlet weak var proteinCount: UILabel!
    @IBOutlet weak var fatCount: UILabel!
    
    // MARK: - Properties -
    static var height: CGFloat = 40.0
    
    // MARK: - Interface -
    func fillFooter(mealTimes: [Mealtime]) {
//        var calories: Int = 0
//        var protein: Int = 0
//        var fat: Int = 0
//        var carbohydrates: Int = 0
//
//        for item in mealTimes {
//            fat += item.fat ?? 0
//            calories += item.calories ?? 0
//            protein += item.protein ?? 0
//            carbohydrates += item.carbohydrates ?? 0
//        }
//        proteinCount.text = "\(protein) г\nБелки"
//        fatCount.text = "\(fat) г\nЖиры"
//        caloriesCount.text = "\(calories) г\nКкал"
//        carbohydratesCount.text = "\(carbohydrates) г\nУглеводы"
    }
}

