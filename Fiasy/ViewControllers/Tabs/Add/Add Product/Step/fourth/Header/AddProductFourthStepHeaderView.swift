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
        titleLabel.text = section == 0 ? "Информация о продукте" : "Пищевая ценность на 100 г."
    }
    
    func fillRecipeHeader(section: Int) {
        switch section {
        case 0:
            titleLabel.text = "Информация о рецепте"
        case 1:
            titleLabel.text = "Ингредиенты"
        case 2:
            titleLabel.text = "Инструкция"
        default:
            break
        }
    }
}