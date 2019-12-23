//
//  MeasuringWeightDescriptionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringWeightDescriptionCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var descriptiobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: LS(key: .HELP_MEAS_FIRST_TITLE), attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: LS(key: .HELP_MEAS_FIRST_TEXT), attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: LS(key: .HELP_MEAS_SECOND_TITLE), attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: LS(key: .HELP_MEAS_SECOND_TEXT), attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: LS(key: .HELP_MEAS_THIRD_TEXT), attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        descriptiobLabel.attributedText = mutableAttrString
    }
}
