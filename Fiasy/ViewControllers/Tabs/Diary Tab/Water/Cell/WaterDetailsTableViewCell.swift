//
//  WaterDetailsTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Intercom
import Amplitude_iOS
import FirebaseStorage

class WaterDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var slider: TGPDiscreteSlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties -
    private let ref = Database.database().reference()
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSlider()
        
        if let user = UserInfo.sharedInstance.currentUser, let waterCount = user.maxWater {
            setupDescriptionLabel(count: waterCount)
            slider.value = fetchSliderIndex(value: waterCount)
        } else {
            changeState(value: 2.0)
            slider.value = 2.0
        }
    }
    
    // MARK: - Private -
    private func setupSlider() {
        slider.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: TGPDiscreteSlider) {
        //selectedState = sender.value
        changeState(value: sender.value)
    }
    
    private func changeState(value: CGFloat) {
        switch value {
        case 0.0:
            setupDescriptionLabel(count: 1.5)
        case 1.0:
            setupDescriptionLabel(count: 1.75)
        case 2.0:
            setupDescriptionLabel(count: 2)
        case 3.0:
            setupDescriptionLabel(count: 2.25)
        case 4.0:
            setupDescriptionLabel(count: 2.5)
        case 5.0:
            setupDescriptionLabel(count: 2.75)
        case 6.0:
            setupDescriptionLabel(count: 3)
        default:
            break
        }
    }
    
    private func fetchSliderIndex(value: Double) -> CGFloat {
        switch value {
        case 1.5:
            return 0
        case 1.75:
            return 1
        case 2.0:
            return 2
        case 2.25:
            return 3
        case 2.5:
            return 4
        case 2.75:
            return 5
        case 3.0:
            return 6
        default:
            return 2
        }
    }
    
    private func setupDescriptionLabel(count: Double) {
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("USER_LIST").child(uid).child("profile").child("maxWater").setValue(count)
            UserInfo.sharedInstance.currentUser?.maxWater = count
            
            Intercom.logEvent(withName: "add_water_success", metaData: ["change_goal" : count]) // +
            Amplitude.instance()?.logEvent("add_water_success", withEventProperties: ["change_goal" : count]) // +
        }
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                     color: #colorLiteral(red: 0.1752049029, green: 0.6115815043, blue: 0.8576936722, alpha: 1), text: "\(count)".replacingOccurrences(of: ".0", with: "")))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: " литра"))
        descriptionLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    // MARK: - Actions -
    @IBAction func defaultClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Сделать по умолчанию?", message: "\nВсе значения воды буду настроены по умолчанию!", preferredStyle: .alert)
        
        let close = UIAlertAction(title: "Ок", style: .default) { [weak self] (alert) in
            guard let strongSelf = self else { return }
            strongSelf.changeState(value: 2.0)
            strongSelf.slider.value = 2.0
            
            if let uid = Auth.auth().currentUser?.uid {
                strongSelf.ref.child("USER_LIST").child(uid).child("profile").child("maxWater").setValue(2.0)
                UserInfo.sharedInstance.currentUser?.maxWater = 2.0
                Intercom.logEvent(withName: "add_water_success", metaData: ["change_goal" : 2.0]) // +
                Amplitude.instance()?.logEvent("add_water_success", withEventProperties: ["change_goal" : 2.0]) // +
            }
        }
        close.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        alert.addAction(close)
        
        let continueAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        continueAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        alert.addAction(continueAction)
        alert.setValue(NSAttributedString(string: alert.title ?? "", attributes: [.font : UIFont.sfProTextSemibold(size: 17), .foregroundColor : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [.font : UIFont.sfProTextRegular(size: 13), .foregroundColor : #colorLiteral(red: 0.3803474307, green: 0.3804178834, blue: 0.38034302, alpha: 1)]), forKey: "attributedMessage")
        if let vc = UIApplication.getTopMostViewController() {
            vc.present(alert, animated: true)
        }
    }
}
