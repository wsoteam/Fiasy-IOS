//
//  SettingCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var arrowIconImageView: UIImageView!
    @IBOutlet weak var typeIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Interface -
    func fillCell(indexPath: IndexPath, purchaseIsValid: Bool) {
        titleLabel.textColor = #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        arrowIconImageView.image = #imageLiteral(resourceName: "gray_arrow")
        arrowIconImageView.isHidden = false
        
        if purchaseIsValid {
            switch indexPath.row {
            case 0:
                titleLabel.text = "Личные данные"
                typeIconImageView.image = #imageLiteral(resourceName: "Glyph1")
            case 1:
                titleLabel.text = "Норма калорий"
                typeIconImageView.image = #imageLiteral(resourceName: "Glyph")
            case 2:
                titleLabel.text = "Помощь"
                typeIconImageView.image = #imageLiteral(resourceName: "ic-help-24px")
            case 3:
                titleLabel.text = "Выход"
                titleLabel.textColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
                typeIconImageView.image = #imageLiteral(resourceName: "ic-exit-to-app-48px")
                arrowIconImageView.isHidden = true
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                titleLabel.text = "Premium аккаунт"
                typeIconImageView.image = #imageLiteral(resourceName: "diamond")
                titleLabel.textColor = #colorLiteral(red: 0.950156033, green: 0.605353117, blue: 0.2954440117, alpha: 1)
                arrowIconImageView.image = #imageLiteral(resourceName: "arrow_premium")
            case 1:
                titleLabel.text = "Промокоды"
                typeIconImageView.image = #imageLiteral(resourceName: "gift_icon")
                
            case 2:
                titleLabel.text = "Личные данные"
                typeIconImageView.image = #imageLiteral(resourceName: "Glyph1")
            case 3:
                titleLabel.text = "Норма калорий"
                typeIconImageView.image = #imageLiteral(resourceName: "Glyph")
            case 4:
                titleLabel.text = "Помощь"
                typeIconImageView.image = #imageLiteral(resourceName: "ic-help-24px")
            case 5:
                titleLabel.text = "Выход"
                titleLabel.textColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
                typeIconImageView.image = #imageLiteral(resourceName: "ic-exit-to-app-48px")
                arrowIconImageView.isHidden = true
            default:
                break
            }
        }
    }
}
