//
//  DetailsActivityTableViewCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 9/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DetailsActivityTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customSlider: CustomSlider!
    @IBOutlet weak var caloriesSpentLabel: UILabel!

    // MARK: - Properties -
    private var model: ActivityElement?
    private var selectedValue: Int = 0
    private var quantity: Int = 0
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()

        fillDefaultSlider()
    }
    
    // MARK: - Interface -
    func fillCell(_ model: ActivityElement?) {
        self.model = model
        
        nameLabel.text = model?.name
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
        }
    }
    
    @IBAction func addDiaryClicked(_ sender: Any) {
        guard let model = self.model, self.quantity > 0 else {
            if let vc = UIApplication.getTopMostViewController() {
                AlertComponent.sharedInctance.showAlertMessage(message: "Вам нужно добавить время активности", vc: vc)
            }
            return
        }
        
        let selectedDate = UserInfo.sharedInstance.selectedDate ?? Date()
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
        
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("USER_LIST").child(uid).child("activities")
            let userData = ["title": model.name, "count": model.count, "calories": model.calories, "time" : model.time, "added_time" : selectedValue, "burned" : self.quantity, "day": day, "year": year, "month": month] as [String : Any]
            ref.childByAutoId().setValue(userData)
            UserInfo.sharedInstance.reloadActiveContent = true
            showConfirmScreen()
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
    
    private func showConfirmScreen() {
        if let vc = UIApplication.getTopMostViewController() as? DetailsActivityViewController {
            let alert = UIAlertController(title: "Внимание", message: "Активность добавлена в ваш дневник", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                vc.navigationController?.popViewController(animated: true)
            }))
            vc.present(alert, animated: true)
        }
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
