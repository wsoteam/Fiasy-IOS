//
//  QuizGenderCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Intercom
import Amplitude_iOS

class QuizGenderCell: UICollectionViewCell {

    // MARK: - Outlet -
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    // MARK: - Properties -
    private var delegate: QuizViewOutput?
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isIphone5 {
            bottomHeightConstraint.constant = 10
            topHeightConstraint.constant = 10
        }
        Intercom.logEvent(withName: "question_next", metaData: ["question" : "male"]) //
        Amplitude.instance()?.logEvent("question_next", withEventProperties: ["question" : "male"]) //
    }
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: "Выберите ваш пол")
        delegate.changeStateBackButton(hidden: true)
        delegate.changePageControl(index: 0)
        
        if let _ = UserInfo.sharedInstance.registrationFlow.gender {
            delegate.changeStateNextButton(state: true)
        }
    }
    
    // MARK: - Actions -
    @IBAction func genderClicked(_ sender: UIButton) {
        delegate?.changeStateNextButton(state: true)
        titleLabel.alpha = 1.0
        switch sender.tag {
        case 0:
            leftImage.image = #imageLiteral(resourceName: "Group (20)")
            rightImage.image = #imageLiteral(resourceName: "Group 2 (2)")
            titleLabel.text = "Вы выбрали женщину"
            UserInfo.sharedInstance.registrationFlow.gender = 0
        case 1:
            leftImage.image = #imageLiteral(resourceName: "Group (19)")
            rightImage.image = #imageLiteral(resourceName: "Group 2 (3)")
            titleLabel.text = "Вы выбрали мужчину"
            UserInfo.sharedInstance.registrationFlow.gender = 1
        default:
            break
        }
    }
}
