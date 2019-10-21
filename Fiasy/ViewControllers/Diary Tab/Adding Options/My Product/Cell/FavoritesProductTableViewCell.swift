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
        if let calor = favorite.calories, calor != -1.0 {
            let count = calor * 100
            if "\(count.displayOnly(count: 2))".contains("0.0") {
                caloriesLabel.text = "\(count.displayOnly(count: 2)) Ккал"
            } else {
                caloriesLabel.text = "\(count.displayOnly(count: 2)) Ккал".replacingOccurrences(of: ".0", with: "")
            }
        } else {
            caloriesLabel.text = "0 Ккал"
        }
        
        if let proteins = favorite.proteins, proteins != -1.0 {
            let count = proteins * 100
            if "\(count.displayOnly(count: 2))".contains("0.0") {
                proteinLabel.text = "Б. \(count.displayOnly(count: 2))"
            } else {
                proteinLabel.text = "Б. \(count.displayOnly(count: 2))".replacingOccurrences(of: ".0", with: "")
            }
        } else {
            proteinLabel.text = "0 Ккал"
        }
        
        if let fats = favorite.fats, fats != -1.0 {
            let count = fats * 100
            if "\(count.displayOnly(count: 2))".contains("0.0") {
                fatLabel.text = "Ж. \(count.displayOnly(count: 2))"
            } else {
                fatLabel.text = "Ж. \(count.displayOnly(count: 2))".replacingOccurrences(of: ".0", with: "")
            }
        } else {
            fatLabel.text = "0 Ккал"
        }
        
        if let carbohydrates = favorite.carbohydrates, carbohydrates != -1.0 {
            let count = carbohydrates * 100
            if "\(count.displayOnly(count: 2))".contains("0.0") {
                carbohydratesLabel.text = "У. \(count.displayOnly(count: 2))"
            } else {
                carbohydratesLabel.text = "У. \(count.displayOnly(count: 2))".replacingOccurrences(of: ".0", with: "")
            }
        } else {
            carbohydratesLabel.text = "0 Ккал"
        }
    }
    
    func fetchFavorite() -> Favorite? {
        return self.favorite
    }
}
