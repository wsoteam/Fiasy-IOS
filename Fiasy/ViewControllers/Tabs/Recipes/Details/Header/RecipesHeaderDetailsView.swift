//
//  RecipesHeaderDetailsView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class RecipesHeaderDetailsView: UITableViewHeaderFooterView {
    
    //MARK: - Outlet's -
    @IBOutlet weak var recipeImageView: UIImageView!
    
    //MARK: - Properties -
    static let headerHeight: CGFloat = 260.0

    //MARK: - Interface -
    func fillHeader(imageUrl: String?) {
        if let path = imageUrl, let url = try? path.asURL() {
            recipeImageView.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            recipeImageView.kf.setImage(with: resource)
        }
    }
}
