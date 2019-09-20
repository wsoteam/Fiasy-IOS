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
    
    //MARK: - Properties -
    
    //MARK: - Interface -
    func fillCell(info: SecondProduct) {
        productNameLabel.text = "\(info.name ?? "")"
        
        if let brand = info.brand, let name = brand.name {
            productWeightLabel.text = "\(name) • \(info.portion ?? 100) г.".replacingOccurrences(of: ".0", with: "")
        } else {
            productWeightLabel.text = "\(info.portion ?? 100) г.".replacingOccurrences(of: ".0", with: "")
        }
        caloriesLabel.text = "\(String(Double((info.calories ?? 0.0) * 100).rounded(toPlaces: 2))) Ккал".replacingOccurrences(of: ".0", with: "")
    }
    
    func fillProductCell(info: Product) {
        productNameLabel.text = "\(info.name ?? "")"
        productWeightLabel.text = "\(info.brend ?? "") • \(info.portion ?? 100) г.".replacingOccurrences(of: ".0", with: "")
        caloriesLabel.text = "\(String(Double((info.calories ?? 0.0) * 100).rounded(toPlaces: 2))) Ккал".replacingOccurrences(of: ".0", with: "")
    }
}
