//
//  LimitDiaryTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/9/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class LimitDiaryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var leftCaloriesLabel: UILabel!
    @IBOutlet weak var endedLabel: UILabel!
    @IBOutlet weak var caloriesProgress: UIProgressView!
    @IBOutlet weak var proteinProgress: UIProgressView!
    @IBOutlet weak var fatProgress: UIProgressView!
    @IBOutlet weak var carbohydratesProgress: UIProgressView!
    @IBOutlet weak var carbohydratesCountLabel: UILabel!
    @IBOutlet weak var fatCountLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var eatenLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    // MARK: - Properties -
    private var date: Date = Date()
    private var delegate: DiaryDisplayManagerDelegate?
    
    // MARK: - Interface -
    func fillCell(selectedDate: Date, delegate: DiaryDisplayManagerDelegate) {
        self.date = selectedDate
        self.delegate = delegate
        setupTopContainer(date: selectedDate)
    }
    
    // MARK: - Private -
    private func setupTopContainer(date: Date) {
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
        
        var calories: Int = 0
        var protein: Int = 0
        var fat: Int = 0
        var carbohydrates: Int = 0
        
        var isContains: Bool = false
        var mealTime: [Mealtime] = []
        if !UserInfo.sharedInstance.allMealtime.isEmpty {
            for item in UserInfo.sharedInstance.allMealtime where item.day == day && item.month == month && item.year == year {
                
                fat += item.fat ?? 0
                calories += item.calories ?? 0
                protein += item.protein ?? 0
                carbohydrates += item.carbohydrates ?? 0
                isContains = true
                mealTime.append(item)
            }
        }
        self.delegate?.sortMealTime(mealTime: mealTime)
        if let user = UserInfo.sharedInstance.currentUser {
            fillTargetLabel(target: (user.maxKcal ?? 0))
            let currentCalories = ((user.maxKcal ?? 0) - calories)
            fatCountLabel.text = "\(fat) из \(user.maxFat ?? 0)"
            endedLabel.text = (user.maxKcal ?? 0) >= calories ? "Осталось" : "Привышение"
            leftCaloriesLabel.text = (user.maxKcal ?? 0) >= calories ? "\(currentCalories)" : "-\(calories - (user.maxKcal ?? 0))"
            carbohydratesCountLabel.text = "\(carbohydrates) из \(user.maxCarbo ?? 0)"
            proteinLabel.text = "\(protein) из \(user.maxProt ?? 0)"
            
            carbohydratesProgress.progress = Float(carbohydrates) / Float(user.maxCarbo ?? 0)
            carbohydratesProgress.progressTintColor = Float(carbohydrates) > Float(user.maxCarbo ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            fatProgress.progress = Float(fat) / Float(user.maxFat ?? 0)
            fatProgress.progressTintColor = Float(fat) > Float(user.maxFat ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            caloriesProgress.progress = Float(calories) / Float(user.maxKcal ?? 0)
            caloriesProgress.progressTintColor = Float(calories) > Float(user.maxKcal ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            proteinProgress.progress = Float(protein) / Float(user.maxProt ?? 0)
            proteinProgress.progressTintColor = Float(protein) > Float(user.maxProt ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            
            eatenLabel.text = "\(calories)"
        }
    }
    
    private func fillTargetLabel(target: Int) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 17),
                                    color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "Ежедневная норма = ", underline: false))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                    color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "\(target) Ккал", underline: true))
        targetLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String, underline: Bool) -> NSAttributedString {
        if underline {
            return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color, .underlineStyle : NSUnderlineStyle.single.rawValue])
        } else {
            return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        }
    }
}
