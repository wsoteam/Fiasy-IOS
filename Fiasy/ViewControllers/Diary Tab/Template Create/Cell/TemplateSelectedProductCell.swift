//
//  TemplateSelectedProductCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class TemplateSelectedProductCell: SwipeTableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(product: SecondProduct) {
        topLabel.text = product.name
        bottomLabel.text = "\(Int(((product.calories ?? 0.0) * 100).rounded(toPlaces: 0))) \(LS(key: .CALORIES_UNIT)) • 100 \(LS(key: .GRAMS_UNIT))"
    }
}
