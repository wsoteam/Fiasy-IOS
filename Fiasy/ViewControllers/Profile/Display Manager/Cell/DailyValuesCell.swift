//
//  DailyValuesCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DailyValuesCell: UITableViewCell {
    
    //MARK: - IBOutlet's -
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    //MARK: - Interface -
    func fillCell(calories: String, waters: String) {
        caloriesLabel.attributedText = fillReadings(first: "Калории", second: calories)
        waterLabel.attributedText = fillReadings(first: "Вода", second: waters)
    }
    
    //MARK: - Private -
    private func fillReadings(first: String, second: String) -> NSMutableAttributedString {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoLight(size: 14),
                            color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: first))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 16),
                            color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\n\(second)"))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        return mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
}
