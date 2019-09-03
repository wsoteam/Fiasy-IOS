//
//  ArticleCollectionViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import VisualEffectView

class ArticleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alphaView: UIView!
    
    //MARK: - Properties -
    private var model: ArticleModel?
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
    }
    
    //MARK: - Interface -
    func fillRow(model: ArticleModel) {
        self.model = model
        
        articleImageView.image = model.image
        nameLabel.text = model.name
        
        alphaView.backgroundColor = model.alphaViewColor
    }
}
