//
//  ArticlesListTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import VisualEffectView

class ArticlesListTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alphaView: UIView!
    
    // MARK: - Properties -
    private var model: ArticleModel?
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
        
        premiumContainerView.clipsToBounds = true
        premiumContainerView.layer.cornerRadius = 8
        premiumContainerView.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    // MARK: - Interface -
    func fillRow(model: ArticleModel) {
        self.model = model
        
        articleImageView.image = model.image
        nameLabel.text = model.name
        
        premiumContainerView.isHidden = !model.premium
        alphaView.backgroundColor = model.alphaViewColor
    }
}
