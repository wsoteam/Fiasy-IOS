//
//  ProfileAvatarTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileAvatarTableViewCell: UITableViewCell {

    // MARK: - Outlet -
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carboLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    @IBOutlet weak var standartLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var dayTargetLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bottomContainerView: UIView!
    
    // MARK: - Properties -
    private var indexCell: IndexPath?
    private var delegate: ProfileDisplayDelegate?
    
    // MARK: - Interface -
    func fillCell(delegate: ProfileDisplayDelegate, indexCell: IndexPath, state: Bool) {
        self.delegate = delegate
        self.indexCell = indexCell
        
        fatsLabel.text = LS(key: .FAT)
        carboLabel.text = LS(key: .CARBOHYDRATES)
        proteinsLabel.text = LS(key: .PROTEIN)
        standartLabel.text = "\(LS(key: .NUTRITION_PLAN)) - \(LS(key: .STANDARD))"
        guard let profile = UserInfo.sharedInstance.currentUser else { return }
        arrowImageView.image = state ? #imageLiteral(resourceName: "Arrow_top-1") : #imageLiteral(resourceName: "Arrow_down-1")
        bottomContainerView.isHidden = state ? false : true
        
        if let image = UserInfo.sharedInstance.currentUser?.temporaryPicture {
            avatarImageView.image = image
        } else {
            if let path = UserInfo.sharedInstance.currentUser?.photoUrl, let url = try? path.asURL(), !path.isEmpty && path != "default" {
                avatarImageView.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                avatarImageView.kf.setImage(with: resource)
            } else {
                avatarImageView.image = UserInfo.sharedInstance.userGender.avatarImage
            }
        }

        if let first = profile.firstName, first != "default" && !first.isEmpty {
            if let last = profile.lastName, last != "default" && !last.isEmpty {
                nameLabel.text = "\(first)\n\(last)"
            } else {
                nameLabel.text = "\(first)"
            }
        } else {
            nameLabel.text = LS(key: .YOUR_NAME)
        }
        
        fatLabel.text = "\(profile.maxFat ?? 0) \(LS(key: .GRAMS_UNIT))"
        proteinLabel.text = "\(profile.maxProt ?? 0) \(LS(key: .GRAMS_UNIT))"
        carbohydratesLabel.text = "\(profile.maxCarbo ?? 0) \(LS(key: .GRAMS_UNIT))"
        dayTargetLabel.attributedText = fillCalories(count: profile.maxKcal ?? 0)
    }
    
    // MARK: - Private -
    private func fillCalories(count: Int) -> NSMutableAttributedString {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 15),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(LS(key: .DAILY_GOAL)) –– "))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 15),
                                                     color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "\(count) \(LS(key: .CALORIES_UNIT))"))
        return mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    // MARK: - Actions -
    @IBAction func arrowClicked(_ sender: UIButton) {
        guard let index = indexCell else { return }
        delegate?.arrowButtonClicked(indexPath: index)
    }
}
