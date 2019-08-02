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
        caloriesCountLabel.text = "\(mealTime.calories ?? 0)\nккал"
        productWeight.text = "Вес: \(mealTime.weight ?? 0)г"
        separatorView.isHidden = !isContainNext
    }
}
