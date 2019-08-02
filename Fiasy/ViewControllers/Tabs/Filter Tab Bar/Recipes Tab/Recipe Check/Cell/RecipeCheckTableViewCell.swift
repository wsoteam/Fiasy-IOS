//
//  RecipeCheckTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/30/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class RecipeCheckTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(flow: AddRecipeFlow, index: Int) {
        switch index {
        case 0:
            titleLabel.text = "Название рецепта"
            var recipeName: String = ""
            let fullNameArr = (flow.recipeName ?? "").split{$0 == " "}.map(String.init)
            for item in fullNameArr where !item.isEmpty {
                recipeName = recipeName.isEmpty ? item : recipeName + " \(item)"
            }
            nameLabel.text = recipeName
        case 1:
            titleLabel.text = "Время приготовления"
            if let time = flow.time {
                nameLabel.text = "\(Int(time) ?? 0) мин."
            }
        case 2:
            titleLabel.text = "Сложность"
            nameLabel.text = flow.complexity
        default:
            break
        }
    }
}
