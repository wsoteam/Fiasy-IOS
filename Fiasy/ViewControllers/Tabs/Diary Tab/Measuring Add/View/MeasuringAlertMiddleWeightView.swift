//
//  MeasuringAlertMiddleWeightView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringAlertMiddleWeightView: UIView {
    
    // MARK: - Outlet's -
    @IBOutlet weak var alertTitleLabel: UILabel!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: "\(LS(key: .MEASURING_TITLE5))", attributes: [.font: UIFont.sfProTextMedium(size: 13), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: "\n\(LS(key: .MEASURING_TITLE6))", attributes: [.font: UIFont.sfProTextMedium(size: 13), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1),  .underlineStyle : NSUnderlineStyle.single.rawValue]))
        alertTitleLabel.attributedText = mutableAttrString
    }
    
    // MARK: - Properties -
    private var delegate: MeasuringCellDelegate?
    
    // MARK: - Interface -
    func fillView(delegate: MeasuringCellDelegate) {
        self.delegate = delegate
    }
    
    func secondFillView(delegate: MeasuringCellDelegate) {
        self.delegate = delegate
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: "\(LS(key: .MEASURING_TITLE14))", attributes: [.font: UIFont.sfProTextMedium(size: 13), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1),  .underlineStyle : NSUnderlineStyle.single.rawValue]))
        alertTitleLabel.attributedText = mutableAttrString
    }
    
    // MARK: - Actions -
    @IBAction func detailsAlertClicked(_ sender: Any) {
        self.delegate?.showDescription()
    }
}
