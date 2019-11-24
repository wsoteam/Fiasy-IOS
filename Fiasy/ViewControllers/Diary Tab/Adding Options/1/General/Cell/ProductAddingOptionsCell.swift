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
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(_ indexPath: IndexPath) {
        topConstraint.constant = 26
        switch indexPath.row {
        case 0:
            topConstraint.constant = 6
            titleLabel.text = "Найти продукт по штрих-коду"
            listImageView.image = #imageLiteral(resourceName: "price-scan-scanner-bar-barcode-code-2 (1)")
        case 1:
            titleLabel.text = "Избранное"
            listImageView.image = #imageLiteral(resourceName: "like_addprod")
        case 2:
            titleLabel.text = "Шаблоны"
            listImageView.image = #imageLiteral(resourceName: "Group 43")
        case 3:
            titleLabel.text = "Мои блюда"
            listImageView.image = #imageLiteral(resourceName: "test_34")
        case 4:
            titleLabel.text = "Мои продукты"
            listImageView.image = #imageLiteral(resourceName: "my_prod")
        default:
            break
        }
    }
}
