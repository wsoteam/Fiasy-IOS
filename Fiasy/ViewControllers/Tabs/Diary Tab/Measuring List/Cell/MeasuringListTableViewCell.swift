//
//  MeasuringListTableViewCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringListTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    // MARK: - Properties -
    private var measuring: Measuring?
    
    // MARK: - Interface -
    func fillCell(measuring: Measuring) {
        self.measuring = measuring
        
        if let date = measuring.date {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier:"GMT")
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateLabel.text =  dateFormatter.string(from: date)
        }        
        fillAmount(count: measuring.weight ?? 0.0)
    }
    
    // MARK: - Private -
    private func fillAmount(count: Double) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: "\(count)", attributes: [ .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: " кг", attributes: [ .foregroundColor: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1)]))
        amountLabel.attributedText = mutableAttrString
    }
}
