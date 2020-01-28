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
    @IBOutlet weak var proteinTitleLabel: UILabel!
    @IBOutlet weak var carboTitleLabel: UILabel!
    @IBOutlet weak var fatTitleLabel: UILabel!
    @IBOutlet weak var burntTitleLabel: UILabel!
    @IBOutlet weak var eatenTitleLabel: UILabel!
    @IBOutlet weak var wellLabel: UILabel!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eatenTitleLabel.text = LS(key: .EATEN_UP)
        burntTitleLabel.text = LS(key: .BURNT)
        fatTitleLabel.text = "\(LS(key: .FAT).capitalizeFirst) (\(LS(key: .GRAMS_UNIT)))"
        carboTitleLabel.text = "\(LS(key: .CARBOHYDRATES).capitalizeFirst) (\(LS(key: .GRAMS_UNIT)))"
        proteinTitleLabel.text = "\(LS(key: .PROTEIN).capitalizeFirst) (\(LS(key: .GRAMS_UNIT)))"
    }
    
    // MARK: - Interface -
    func fillCell(selectedDate: Date, delegate: DiaryDisplayManagerDelegate, activityCount: Int) {
        self.date = selectedDate
        self.delegate = delegate
        
        setupTopContainer(date: selectedDate, activityCount: activityCount)
    }
    
    // MARK: - Private -
    private func setupTopContainer(date: Date, activityCount: Int) {
        wellLabel.text = "\(activityCount)"
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
        
        var calories1: Double = 0.0
        var protein1: Double = 0.0
        var fat1: Double = 0.0
        var carbohydrates1: Double = 0.0
        
        var isContains: Bool = false
        //var mealTime: [Mealtime] = []
        if !UserInfo.sharedInstance.allMealtime.isEmpty {
            for item in UserInfo.sharedInstance.allMealtime where item.day == day && item.month == month && item.year == year {
                
                var portionSize: Int?
                if let id = item.portionId, !item.measurementUnits.isEmpty {
                    for portion in item.measurementUnits where portion.id == id {
                        portionSize = portion.amount
                        break
                    }
                }
                
//                if item.isMineProduct == true && !item.measurementUnits.isEmpty {
//                    if let first = item.measurementUnits.first {
//                        portionSize = first.amount
//                    }
//                }
                
                if let weight = item.weight {
                    if item.isDish == true {
                        for item in item.products {
                            fat1 += Double(weight) * (item.fats ?? 0.0)
                            protein1 += Double(weight) * (item.proteins ?? 0.0)
                            calories1 += Double(weight) * (item.calories ?? 0.0)
                            carbohydrates1 += Double(weight) * (item.carbohydrates ?? 0.0)
                        }
                    } else {
                        if let mult = portionSize {
                            fat1 += Double(weight * mult) * (item.fat ?? 0.0)
                            protein1 += Double(weight * mult) * (item.protein ?? 0.0)
                            calories1 += Double(weight * mult) * (item.calories ?? 0.0)
                            carbohydrates1 += Double(weight * mult) * (item.carbohydrates ?? 0.0)
                        } else {
                            fat1 += Double(weight) * (item.fat ?? 0.0)
                            protein1 += Double(weight) * (item.protein ?? 0.0)
                            calories1 += Double(weight) * (item.calories ?? 0.0)
                            carbohydrates1 += Double(weight) * (item.carbohydrates ?? 0.0)
                        }
                    }
                }
                isContains = true
                //mealTime.append(item)
            }
        }
        var calories: Int = Int(calories1.rounded(toPlaces: 0).displayOnly(count: 0))
        var protein: Int = Int(protein1.rounded(toPlaces: 0).displayOnly(count: 0))
        var fat: Int = Int(fat1.rounded(toPlaces: 0).displayOnly(count: 0))
        var carbohydrates: Int = Int(carbohydrates1.rounded(toPlaces: 0).displayOnly(count: 0))
        //self.delegate?.sortMealTime(mealTime: mealTime)
        if let user = UserInfo.sharedInstance.currentUser {
            fillTargetLabel(target: (user.maxKcal ?? 0))
            let currentCalories = ((user.maxKcal ?? 0) - calories) + activityCount
            fatCountLabel.text = "\(fat) из \(user.maxFat ?? 0)"
            endedLabel.text = (user.maxKcal ?? 0) >= calories ? LS(key: .LEFT).capitalizeFirst : LS(key: .EXCESS)
            leftCaloriesLabel.text = ((user.maxKcal ?? 0) + activityCount) >= calories ? "\(currentCalories)" : "+\(calories - ((user.maxKcal ?? 0) + activityCount))"
            carbohydratesCountLabel.text = "\(carbohydrates) из \(user.maxCarbo ?? 0)"
            proteinLabel.text = "\(protein) из \(user.maxProt ?? 0)"
            
            carbohydratesProgress.progress = Float(carbohydrates) / Float(user.maxCarbo ?? 0)
            carbohydratesProgress.progressTintColor = Float(carbohydrates) > Float(user.maxCarbo ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            fatProgress.progress = Float(fat) / Float(user.maxFat ?? 0)
            fatProgress.progressTintColor = Float(fat) > Float(user.maxFat ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            caloriesProgress.progress = Float(calories - activityCount) / Float(user.maxKcal ?? 0)
            caloriesProgress.progressTintColor = Float(calories - activityCount) > Float(user.maxKcal ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            proteinProgress.progress = Float(protein) / Float(user.maxProt ?? 0)
            proteinProgress.progressTintColor = Float(protein) > Float(user.maxProt ?? 0) ? #colorLiteral(red: 0.9229121804, green: 0.4868420959, blue: 0.4857618213, alpha: 1) : #colorLiteral(red: 0.9420654178, green: 0.6840462089, blue: 0.4467554092, alpha: 1)
            
            eatenLabel.text = "\(calories)"
        }
    }
    
    private func fillTargetLabel(target: Int) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 17),
                                    color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(LS(key: .DIARY_DAILY_RATE)) = ", underline: false))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                    color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "\(target) \(LS(key: .CALORIES_UNIT).capitalizeFirst)", underline: true))
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
