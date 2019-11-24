//
//  ListExpertArticlesTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ListExpertArticlesTableCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet var daysLabel: [UILabel]!
    @IBOutlet var daysButton: [RadioButton]!
    
    // MARK: - Interface -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for (index, item) in daysLabel.enumerated() {
            fillTextDay(day: index, label: item)
        }
    }
    
    // MARK: - Private -
    private func fillTextDay(day: Int, label: UILabel) {
        let mutableAttrString = NSMutableAttributedString()
        switch day {
        case 0:
            daysButton[0].isOn = true
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "С чего начать?", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        case 1:
            daysButton[day].isOn = false
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "Ошибки", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        case 2:
            daysButton[day].isOn = false
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "Выгоды", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        case 3:
            daysButton[day].isOn = false
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "Возможности", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        case 4:
            daysButton[day].isOn = false
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "Мотивация", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        case 5:
            daysButton[day].isOn = false
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "Душевное состояние", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        case 6:
            daysButton[day].isOn = false
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "Разум", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        case 7:
            daysButton[day].isOn = false
            mutableAttrString.append(NSAttributedString(string: " День \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
            mutableAttrString.append(NSAttributedString(string: "Тело", attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
            label.attributedText = mutableAttrString
        default:
            break
        }
    }
}
