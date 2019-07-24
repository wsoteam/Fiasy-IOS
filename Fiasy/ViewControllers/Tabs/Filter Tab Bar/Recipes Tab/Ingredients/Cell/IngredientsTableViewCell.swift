//
//  IngredientsTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    // MARK: - Properties -
    private var product: Product?
    
    // MARK: - Interface -
    func fillCell(product: Product) {
        self.product = product
        
        nameLabel.text = product.name
        weightLabel.text = "\(product.productWeightByAdd ?? 0) г."
        
        if let calor = product.calories {
           caloriesLabel.text = "\(Double(calor * Double((product.productWeightByAdd ?? 0))).rounded(toPlaces: 1)) Ккал"
        } else {
            caloriesLabel.text = "0 Ккал"
        }
    }
}
