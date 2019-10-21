//
//  ProductAddingOptionsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProductAddingOptionsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            titleLabel.text = "Избранное"
            listImageView.image = #imageLiteral(resourceName: "test_33")
        case 1:
            titleLabel.text = "Шаблоны"
            listImageView.image = #imageLiteral(resourceName: "diary_2")
        case 2:
            titleLabel.text = "Мои блюда"
            listImageView.image = #imageLiteral(resourceName: "test_34")
        case 3:
            titleLabel.text = "Мои продукты"
            listImageView.image = #imageLiteral(resourceName: "test_35")
        default:
            break
        }
    }
}
