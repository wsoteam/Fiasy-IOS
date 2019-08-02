//
//  ProfileIndicatorCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProfileIndicatorCell: UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var targetButton: UIButton!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    //MARK: - Properties -
    private var delegate: ProfileDelegate?
    
    //MARK: - Interface -
    func fillCell(delegate: ProfileDelegate) {
        self.delegate = delegate
        if let type = UserInfo.sharedInstance.currentUser?.difficultyLevel {
            targetButton.setTitle(UserInfo.sharedInstance.currentUser?.difficultyLevel, for: .normal)
            targetButton.setTitleColor(TargetType(rawValue: type)?.targetColor, for: .normal)
        }
        carbohydratesLabel.text = "\(UserInfo.sharedInstance.currentUser?.maxCarbo ?? 0) г"
        fatLabel.text = "\(UserInfo.sharedInstance.currentUser?.maxFat ?? 0) г"
        proteinLabel.text = "\(UserInfo.sharedInstance.currentUser?.maxProt ?? 0) г"
    }
    
    //MARK: - Actions -
    @IBAction func complexityClicked(_ sender: Any) {
        delegate?.showComplexityScreen()
    }
    
    @IBAction func profileEditClicked(_ sender: Any) {
        delegate?.editProfile()
    }
}
