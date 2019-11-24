//
//  ProfileActivityViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/28/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProfileActivityViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleNavigationLabel: UILabel!
    @IBOutlet weak var slider: TGPDiscreteSlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectedStateImageView: UIImageView!
    
    //MARK: - Properties -
    //private var delegate: QuizViewOutput?
    private var selectedState: CGFloat = 0.0
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        selectedState = UserInfo.sharedInstance.editActivity
        changeState(value: UserInfo.sharedInstance.editActivity)
        slider.value = UserInfo.sharedInstance.editActivity
        titleNavigationLabel.text = LS(key: .ACTIVITY_NAVIGATION)
    }
    
    // MARK: - Private -
    private func setupSlider() {
        slider.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: TGPDiscreteSlider) {
        if sender.value != selectedState {
            selectedState = sender.value
            changeState(value: selectedState)
        }
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func changeState(value: CGFloat) {
        switch value {
        case 0.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "1_step")
            descriptionLabel.text = LS(key: .FIRST_ACTIVITY)
        case 1.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "2_step")
            descriptionLabel.text = LS(key: .SECOND_ACTIVITY)
        case 2.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "3_step")
            descriptionLabel.text = LS(key: .THIRD_ACTIVITY)
        case 3.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "4_step")
            descriptionLabel.text = LS(key: .FOURTH_ACTIVITY)
        case 4.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "5_step")
            descriptionLabel.text = LS(key: .FIVE_ACTIVITY)
        case 5.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "6_step")
            descriptionLabel.text = LS(key: .SIX_ACTIVITY)
        case 6.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "7_step")
            descriptionLabel.text = LS(key: .SEVEN_ACTIVITY)
        default:
            break
        }
        UserInfo.sharedInstance.editActivity = value
    }
}
