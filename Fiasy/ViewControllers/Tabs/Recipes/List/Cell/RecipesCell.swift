//
//  RecipesCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class RecipesCell: UICollectionViewCell {
    
    //MARK: - Outlet's -
    @IBOutlet weak var recipieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    //MARK: - Interface -
    func fillCell(by recipe: Listrecipe) {
        nameLabel.text = recipe.name
        caloriesLabel.text = "\(recipe.calories ?? 0) Ккал"
        
        if let path = recipe.url, let url = try? path.asURL() {
            recipieImageView.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            recipieImageView.kf.setImage(with: resource)
        }
    }
}
