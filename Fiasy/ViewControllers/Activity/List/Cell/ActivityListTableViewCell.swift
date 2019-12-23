//
//  ActivityListTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ActivityListTableViewCell: SwipeTableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Properties -
    
    //MARK: - Interface -
    func fillCell(_ model: ActivityElement) {
        caloriesLabel.text = "\((model.count ?? 0) * 30) \(LS(key: .CALORIES_UNIT))"
        nameLabel.text = model.name
        timeLabel.text = "30 \(LS(key: .MINUTES))"
    }
    
    func fillSecondCell(_ model: ActivityElement) {
        caloriesLabel.text = "\(model.calories ?? 0) \(LS(key: .CALORIES_UNIT))"
        nameLabel.text = model.name
        timeLabel.text = "\(model.time ?? 0) \(LS(key: .MINUTES))"
    }
    
    func fillByDiaryCell(_ model: ActivityElement) {
        nameLabel.text = model.name
        
        caloriesLabel.text = "\(model.burned ?? 0) \(LS(key: .CALORIES_UNIT))"
        
        guard let time = model.addedTime else { return }
        if (time / 60 % 60) > 0 {
            let hours = time / 60 % 60
            let minutes = time % 60
            
            if minutes > 0 {
                timeLabel.text = "\(hours)ч \(minutes)м"
            } else {
                timeLabel.text = "\(hours) \(fetchHoursSuffix(count: minutes))"
            }
        } else {
            let minutes = time % 60
            timeLabel.text = "\(minutes) \(fetchMinutesSuffix(count: minutes))"
        }
    }
    
    private func fetchMinutesSuffix(count: Int) -> String {
        if getPreferredLocale().languageCode == "ru" {
            if count == 1 {
                return " минута"
            } else if count > 1 && count < 5 {
                return " минуты"
            } else {
                return " минут"
            }
        } else {
            return LS(key: .MINUTES)
        }
    }
    
    private func fetchHoursSuffix(count: Int) -> String {
        if getPreferredLocale().languageCode == "ru" {
            if count == 1 {
                return " час"
            } else if count > 4 {
                return " часов"
            } else {
                return " часа"
            }
        } else {
            return LS(key: .BLACK_PREM_HOURS)
        }
    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
