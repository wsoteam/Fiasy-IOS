//
//  ArticlesDetailsTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import VisualEffectView

class ArticlesDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var secondPremContainerView: UIView!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blurView.colorTint = .clear
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
    }
    
    // MARK: - Properties -
    private var model: ArticleModel?
    private var delegate: ArticlesDetailsDelegate?
    
    // MARK: - Interface -
    func fillRow(model: ArticleModel, premState: Bool, delegate: ArticlesDetailsDelegate) {
        self.model = model
        self.delegate = delegate

        articleImageView.image = model.image
        articleNameLabel.text = model.name
        
        messageLabel.attributedText = model.text
        if let description = model.attributedTitle {
            articleDescriptionLabel.attributedText = description
        } else {
            articleDescriptionLabel.text = model.title
        }
        
        if model.premium {
            if premState {
                premiumContainerView.isHidden = true
                secondPremContainerView.isHidden = true
            } else {
                premiumContainerView.isHidden = false
                secondPremContainerView.isHidden = false
            }
        } else {
            premiumContainerView.isHidden = true
            secondPremContainerView.isHidden = true
        }
    }
    
    // MARK: - Actions -
    @IBAction func showPremiumScreen(_ sender: Any) {
        self.delegate?.showPremiumScreen()
    }
}
