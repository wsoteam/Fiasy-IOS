//
//  ProfileTargetViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/28/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Intercom
import Amplitude_iOS

class ProfileTargetViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet var targetTitles: [UILabel]!
    @IBOutlet var targetImages: [UIImageView]!
    
    //MARK: - Properties -
    //private var delegate: QuizViewOutput?
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaultState()
        let target = UserInfo.sharedInstance.editTarget
        if targetImages.indices.contains(target) {
            targetImages[target].image = UIImage.coloredImage(image: fetchTargetImage(index: target), color: #colorLiteral(red: 0.9580997825, green: 0.5739049315, blue: 0.1940318346, alpha: 1))
        }
        if targetTitles.indices.contains(target) {
            targetTitles[target].textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    // MARK: - Actions -
    @IBAction func targetClicked(_ sender: UIButton) {
        Amplitude.instance().logEvent("change_goal") // +
        Intercom.logEvent(withName: "change_goal") // +
        setupDefaultState()
        UserInfo.sharedInstance.editTarget = sender.tag
        if targetImages.indices.contains(sender.tag) {
            targetImages[sender.tag].image = UIImage.coloredImage(image: fetchTargetImage(index: sender.tag), color: #colorLiteral(red: 0.9580997825, green: 0.5739049315, blue: 0.1940318346, alpha: 1))
        }
        if targetTitles.indices.contains(sender.tag) {
            targetTitles[sender.tag].textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
