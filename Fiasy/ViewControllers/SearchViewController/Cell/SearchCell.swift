//
//  SearchCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productWeightLabel: UILabel!
    @IBOutlet weak var squirrelsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    
    //MARK: - Properties -
    
    //MARK: - Interface -
    func fillCell(info: Product) {
        productNameLabel.text = "\(info.name ?? "") (\(info.brend ?? ""))"
        
        fatsLabel.text = "Ж. \(String(Double((info.fats ?? 0.0) * 100).rounded(toPlaces: 2)))"
        squirrelsLabel.text = "Б. \(String(Double((info.proteins ?? 0.0) * 100).rounded(toPlaces: 2)))"
        carbohydratesLabel.text = "У. \(String(Double((info.carbohydrates ?? 0.0) * 100).rounded(toPlaces: 2)))"
        caloriesLabel.text = "Ккал \(String(Double((info.calories ?? 0.0) * 100).rounded(toPlaces: 2)))"
    }
}
