//
//  InsertPremiumLockView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InsertPremiumLockView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    // MARK: - Interface -
    func fillView(index: Int) {
        rightImage.image = #imageLiteral(resourceName: "Shape (4)")
        leftImage.image = #imageLiteral(resourceName: "lock_icon")
        switch index {
        case 0:
            titleLabel.text = "Дневник питания и\nнагрузок"
            leftImage.image = #imageLiteral(resourceName: "Shape (4)")
            backgroundImageView.backgroundColor = #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        case 1:
            titleLabel.text = "Учет\nмакроэлементов"
            backgroundImageView.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        case 2:
            titleLabel.text = "Рецепты"
            backgroundImageView.backgroundColor = #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        case 3:
            titleLabel.text = "Эксклюзивные\nстатьи от диетолога"
            backgroundImageView.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        case 4:
            titleLabel.text = "Планы питания"
            backgroundImageView.backgroundColor = #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        case 5:
            titleLabel.text = "Вся статистика"
            backgroundImageView.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        case 6:
            titleLabel.text = "Учет морфологии\nтела"
            backgroundImageView.backgroundColor = #colorLiteral(red: 0.9960417151, green: 0.980664432, blue: 0.9636668563, alpha: 1)
        default:
            break
        }
    }
}
