//
//  QuizGenderCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class QuizGenderCell: UICollectionViewCell {

    // MARK: - Outlet -
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    //MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    //MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isIphone5 {
            bottomHeightConstraint.constant = 10
            topHeightConstraint.constant = 10
        }
    }
    
    // MARK: - Actions -
    @IBAction func genderClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            leftImage.image = #imageLiteral(resourceName: "Group (20)")
            rightImage.image = #imageLiteral(resourceName: "Group 2 (2)")
        case 1:
            leftImage.image = #imageLiteral(resourceName: "Group (19)")
            rightImage.image = #imageLiteral(resourceName: "Group 2 (3)")
        default:
            break
        }
    }
}
