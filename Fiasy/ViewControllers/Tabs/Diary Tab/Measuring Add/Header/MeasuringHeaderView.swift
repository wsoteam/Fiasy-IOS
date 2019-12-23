//
//  MeasuringHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringHeaderView: UITableViewHeaderFooterView {

    // MARK: - Outlet's -
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties -
    static var height: CGFloat = 40.0
    
    // MARK: - Interface -
    func fillHeaderView(_ allMeasurings: [Measuring]) {
        leftTitleLabel.text = LS(key: .MEAS_TITLE_BOTTOM)
        var list: [Measuring] = []
        for item in allMeasurings where item.type != .weight {
            list.append(item)
        }
        list = list.sorted (by: {$0.timeInMillis > $1.timeInMillis})
        if list.isEmpty {
            descriptionLabel.text = LS(key: .DIARY_MES_1)
        } else {
            if let first = list.first, let date = first.date {
                if Calendar.current.component(.day, from: Date()) == Calendar.current.component(.day, from: date) && Calendar.current.component(.month, from: Date()) == Calendar.current.component(.month, from: date) && Calendar.current.component(.year, from: Date()) == Calendar.current.component(.year, from: date) {
                    descriptionLabel.text = LS(key: .DIARY_MES_11)
                } else {
                    if let diffInDays = Calendar.current.dateComponents([.day], from: date, to: Date()).day {
                        fillHeaderTitle(first: "\(diffInDays) \(fetcPrefix(count: diffInDays))", second: " \(LS(key: .DIARY_MES_12))")
                    }
                }
            }
        }
    }
    
    // MARK: - Private -
    private func fetcPrefix(count: Int) -> String {
        if getPreferredLocale().languageCode == "ru" {
            switch count {
            case 1:
                return "день"
            case 2,3,4:
                return "дня"
            default:
                return "дней"
            }
        } else {
            return LS(key: .DIARY_MES_8)
        }
    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    private func fillHeaderTitle(first: String, second: String) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: first))
        mutableAttrString.append(configureAttrString(by: #colorLiteral(red: 0.7607005835, green: 0.7608326077, blue: 0.7606922984, alpha: 1), text: " \(second)"))
        descriptionLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font:  UIFont.sfProTextMedium(size: 12), .foregroundColor: color])
    }
}
