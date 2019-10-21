//
//  InsertPremiumDescriptionView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InsertPremiumDescriptionView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(index: Int) {
        switch index {
        case 0:
            topButton.setImage(#imageLiteral(resourceName: "prem3"), for: .normal)
            topButton.setTitle(" Эксклюзивные статьи", for: .normal)
            
            bottomLabel.text = "Вы получите доступ к статьям от\nпопулярного диетолога и\nфитнес-тренера"
        case 1:
            topButton.setImage(#imageLiteral(resourceName: "prem4"), for: .normal)
            topButton.setTitle(" База рецептов", for: .normal)
            
            bottomLabel.text = "Легие в приготовление рецепты с\nданными КБЖУ с недорогими, но\nвкусными продуктами"
        case 2:
            topButton.setImage(#imageLiteral(resourceName: "prem5"), for: .normal)
            topButton.setTitle(" Персональные настройки", for: .normal)
            
            bottomLabel.text = "Вы сможете просматривать и\nрегулировать уровень своего КБЖУ"
        case 3:
            topButton.setImage(#imageLiteral(resourceName: "prem6"), for: .normal)
            topButton.setTitle(" Планы питания", for: .normal)
            
            bottomLabel.text = "Готовые планы питания на любой вкус\nи для любой цели"
        case 4:
            topButton.setImage(#imageLiteral(resourceName: "prem7"), for: .normal)
            topButton.setTitle(" Измерения тела", for: .normal)
            
            bottomLabel.text = "Отслеживайте динамику прогресса с\nпомощью подробного анализа\nпараметров своего тела"
        default:
            break
        }
    }
}
