//
//  FavoritesProductTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class FavoritesProductTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    // MARK: - Properties -
    private var favorite: Favorite?
    
    // MARK: - Interface -
    func fillCell(favorite: Favorite) {
        self.favorite = favorite
        
        productNameLabel.text = favorite.name
        if let calor = favorite.calories {
            caloriesLabel.text = "\(calor * 100) Ккал"
        }
        if let proteins = favorite.proteins {
            proteinLabel.text = "Б. \(proteins * 100)"
        }
        if let fats = favorite.fats {
            fatLabel.text = "Ж. \(fats * 100)"
        }
        if let carbohydrates = favorite.carbohydrates {
            carbohydratesLabel.text = "У. \(carbohydrates * 100)"
        }
    }
}
