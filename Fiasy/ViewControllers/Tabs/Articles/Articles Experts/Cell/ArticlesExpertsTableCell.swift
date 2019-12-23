//
//  ArticlesExpertsTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ArticlesExpertsTableCell: UITableViewCell {
    
    // MARK: - Actions -
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dietologNameLabel: UILabel!
    @IBOutlet weak var dietologDescriptionLabel: UILabel!
    @IBOutlet weak var firstContainerLabel: UILabel!
    @IBOutlet weak var secondContainerLabel: UILabel!
    @IBOutlet weak var thirdContainerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = LS(key: .ART_SERIES_AUTHOR_TITLE)
        dietologNameLabel.text = LS(key: .ART_SERIES_AUTHOR_BURLAKOV)
        dietologDescriptionLabel.text = LS(key: .ART_SERIES_AUTHOR_BURLAKOV_BIO)
        firstContainerLabel.text = LS(key: .ART_SERIES_AUTHOR_BURLAKOV_ACHIV1)
        secondContainerLabel.text = LS(key: .ART_SERIES_AUTHOR_BURLAKOV_ACHIV2)
        thirdContainerLabel.text = LS(key: .ART_SERIES_AUTHOR_BURLAKOV_ACHIV3)
        nextButton.setTitle("\(LS(key: .UNBOARDING_NEXT)) ", for: .normal)
    }
    
    func fillCell(show: Bool) {
        bottomContainerView.isHidden = !show
    }
    
    // MARK: - Actions -
    @IBAction func nextClicked(_ sender: Any) {
        if let vc = UIApplication.getTopMostViewController() as? ArticlesExpertsViewController {
            vc.performSegue(withIdentifier: "sequeListExpertArticles", sender: nil)
        }
    }
}
