//
//  TargetSelectedCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Intercom
import Amplitude_iOS

class TargetSelectedCell: UICollectionViewCell {
    
    // MARK: - Outlet -
    @IBOutlet var targetTitles: [UILabel]!
    @IBOutlet var targetImages: [UIImageView]!
    
    //MARK: - Properties -
    private var delegate: QuizViewOutput?
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    //MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDefaultState()
        Intercom.logEvent(withName: "question_next", metaData: ["question" : "goal"]) // +
        Amplitude.instance()?.logEvent("question_next", withEventProperties: ["question" : "goal"]) // +
    }
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: "Выберите свою цель")
        delegate.changeStateBackButton(hidden: false)
        delegate.changePageControl(index: 5)
        
        if let _ = UserInfo.sharedInstance.registrationFlow.target {
            delegate.changeStateNextButton(state: true)
        } else {
            delegate.changeStateNextButton(state: false)
        }
    }
    
    // MARK: - Actions -
    @IBAction func targetClicked(_ sender: UIButton) {
        setupDefaultState()
        UserInfo.sharedInstance.registrationFlow.target = sender.tag
        delegate?.changeStateNextButton(state: true)
        if targetImages.indices.contains(sender.tag) {
            targetImages[sender.tag].image = UIImage.coloredImage(image: fetchTargetImage(index: sender.tag), color: #colorLiteral(red: 0.9580997825, green: 0.5739049315, blue: 0.1940318346, alpha: 1))
        }
        if targetTitles.indices.contains(sender.tag) {
            targetTitles[sender.tag].textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    // MARK: - Private -
    private func setupDefaultState() {
        for item in targetImages {
            switch item.tag {
            case 0:
                item.image = #imageLiteral(resourceName: "Vector (11)")
            case 1:
                item.image = #imageLiteral(resourceName: "Vector (12)")
            case 2:
                item.image = #imageLiteral(resourceName: "Vector (13)")
            case 3:
                item.image = #imageLiteral(resourceName: "Vector (14)")
            default:
                break
            }
        }
        for item in targetTitles {
            item.textColor = #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
        }
    }
    
    private func fetchTargetImage(index: Int) -> UIImage {
        switch index {
        case 0:
            return #imageLiteral(resourceName: "Vector (11)")
        case 1:
            return #imageLiteral(resourceName: "Vector (12)")
        case 2:
            return #imageLiteral(resourceName: "Vector (13)")
        default:
            return #imageLiteral(resourceName: "Vector (14)")
        }
    }
}
