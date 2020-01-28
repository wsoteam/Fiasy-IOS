//
//  NutritionDetailsTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/28/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher

class NutritionDetailsTableCell: UITableViewCell {
    
    // MARK: - Properties -
    private var details: NutritionDetail?
    
    // MARK: - Outlet -
    @IBOutlet weak var nutritionTitleLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    
    // MARK: - Interface -
    func fillCell(details: NutritionDetail?) {
        self.details = details
        
        nutritionTitleLabel.text = details?.name
        if let path = details?.urlImage, let url = try? path.asURL() {
            let resource = ImageResource(downloadURL: url)
            topImageView.kf.setImage(with: resource)
        }
    }
}
