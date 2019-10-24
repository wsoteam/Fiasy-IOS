//
//  MeasuringPremiumTableViewCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringPremiumTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(index: Int) {
        switch index {
        case 0:
            titleLabel.text = "Грудь"
        case 1:
            titleLabel.text = "Талия"
        case 2:
            titleLabel.text = "Бедра"
        default:
            break
        }
    }
}
