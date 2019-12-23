//
//  MeasuringSecondAlertView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/29/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringSecondAlertView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerArrowConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = LS(key: .MEASURING_TITLE7)
    }
    
    // MARK: - Interface -
    func fillView(tag: Int) {
        switch tag {
        case 0:
            centerArrowConstraint.constant = isIphone5 ? -40 : -35
        case 1:
            centerArrowConstraint.constant = isIphone5 ? 4 : 11
        case 2,3,4,5:
            centerArrowConstraint.constant = isIphone5 ? 9 : 8
        case 6:
            centerArrowConstraint.constant = isIphone5 ? 40 : 35
        default:
            break
        }
    }
}
