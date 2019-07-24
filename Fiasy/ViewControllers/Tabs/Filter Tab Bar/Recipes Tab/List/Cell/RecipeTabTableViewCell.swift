//
//  RecipeTabTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class RecipeTabTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var generalImageView: UIImageView!
    
    // MARK: - Properties -

    // MARK: - Interface -
    func fillCell(recipe: Listrecipe) {
        nameLabel.text = recipe.name
        
        if let path = recipe.url {
            self.generalImageView.setImage(with: path)
        }
    }
}
