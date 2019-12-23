//
//  FavoritesActivityEmptyCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class FavoritesActivityEmptyCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionImageView: UIImageView!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.text = LS(key: .EMPTY_FAVORITES).capitalizeFirst
        switch Locale.current.languageCode {
        case "es":
            // испанский
            descriptionImageView.image = #imageLiteral(resourceName: "fav_act_es")
        case "pt":
            // португалия (бразилия)
            descriptionImageView.image = #imageLiteral(resourceName: "fav_act_pt")
        case "en":
            // английский
            descriptionImageView.image = #imageLiteral(resourceName: "fav_act_eng")
        case "de":
            // немецикий
            descriptionImageView.image = #imageLiteral(resourceName: "fav_act_de")
        default:
            // русский
            descriptionImageView.image = #imageLiteral(resourceName: "fav_act_rus")
        }
    }
}
