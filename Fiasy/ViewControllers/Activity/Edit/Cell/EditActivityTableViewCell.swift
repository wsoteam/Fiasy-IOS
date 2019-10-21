//
//  EditActivityTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditActivityTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customSlider: CustomSlider!
    @IBOutlet weak var caloriesSpentLabel: UILabel!
    
    // MARK: - Properties -
    private var model: ActivityElement?
    private var selectedValue: Int = 0
    private var quantity: Int = 0
    
    // MARK: - Interface -
    func fillCell(_ model: ActivityElement?) {
        self.model = model
        
        nameLabel.text = model?.name
        
        if let calories = self.model?.burned, let time = self.model?.addedTime {
            customSlider.value = Float((Double(time) / Double(120)))
            selectedValue = Int(Double((Double(time) / Double(120)) * 120).rounded(toPlaces: 0))
            let count = Int(Double((Double(calories)/Double(time)) * Double(selectedValue)).rounded(toPlaces: 0))
            fillSecondTimeCount(time: selectedValue, calories: count)
        }
    }
    
    // MARK: - Actions -
    @IBAction func sliderValueChange(_ sender: UISlider) {
        selectedValue = Int(Double(sender.value * 120).rounded(toPlaces: 0))
        if let count = self.model?.count, count != 0 {
            fillSecondTimeCount(time: selectedValue, calories: selectedValue * count)
            quantity =  selectedValue * count
        } else if let time = self.model?.time, let calories = self.model?.calories {
            let count = Int(Double((Double(calories)/Double(time)) * Double(selectedValue)).rounded(toPlaces: 0))
            quantity = count
            fillSecondTimeCount(time: selectedValue, calories: count)
        } else if let calories = self.model?.burned, let time = self.model?.addedTime {
            let count = Int(Double((Double(calories)/Double(time)) * Double(selectedValue)).rounded(toPlaces: 0))
            quantity = count
            fillSecondTimeCount(time: selectedValue, calories: count)
        }
    }
    
    @IBAction func addDiaryClicked(_ sender: Any) {
        guard let model = self.model, self.quantity > 0 else {
            if let vc = UIApplication.getTopMostViewController() {
                AlertComponent.sharedInctance.showAlertMessage(message: "Внесите изменения", vc: vc)
            }
            return
        }
        
        if let generalKey = model.generalKey, let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("USER_LIST").child(uid).child("activities").child("\(generalKey)")
            ref.child("added_time").setValue(self.selectedValue)
            ref.child("burned").setValue(self.quantity)
            UserInfo.sharedInstance.reloadActiveContent = true
            if let vc = UIApplication.getTopMostViewController() {
                vc.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Private -
    private func fillDefaultSlider() {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 17),
                                                     color: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "Потрачено калорий"))
        
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 17),
                                                     color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: " = 0\n"))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "за 0 минут"))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        caloriesSpentLabel.attributedText = mutableAttrString
    }
    
    private func fillSecondTimeCount(time: Int, calories: Int) {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 17),
                                                     color: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: "Потрачено калорий"))
        
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 17),
                                                     color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: " = \(calories)\n"))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "за"))
        
        if (time / 60 % 60) > 0 {
            let hours = time / 60 % 60
            let minutes = time % 60
            
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                         color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: " \(hours) ".replacingOccurrences(of: ".0", with: "")))
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                         color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: fetchHoursSuffix(count: hours)))
            if minutes > 0 {
                mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                             color:#colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: " \(minutes) "))
                
                mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                             color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: fetchMinutesSuffix(count: minutes)))
            }
        } else {
            let minutes = time % 60
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                         color:#colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: " \(minutes)"))
            
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 22),
                                                         color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: fetchMinutesSuffix(count: minutes)))
        }
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        caloriesSpentLabel.attributedText = mutableAttrString
    }

    private func fetchMinutesSuffix(count: Int) -> String {
        if count == 1 {
            return " минута"
        } else if count > 1 && count < 5 {
            return " минуты"
        } else {
            return " минут"
        }
    }
    
    private func fetchHoursSuffix(count: Int) -> String {
        if count == 1 {
            return " час"
        } else if count > 4 {
            return " часов"
        } else {
            return " часа"
        }
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
}
