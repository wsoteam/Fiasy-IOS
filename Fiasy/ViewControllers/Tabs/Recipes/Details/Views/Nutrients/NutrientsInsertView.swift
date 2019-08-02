//
//  NutrientsInsertView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class NutrientsInsertView: UIView {
    
    //MARK: - Outlet -
    @IBOutlet weak var premiumViewContainer: UIView!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var leftSideLabel: UILabel!
    @IBOutlet weak var rightSideLabel: UILabel!

    //MARK: - Interface -
    func fillView(leftName: String, rightName: String, isTitle: Bool, isOwn: Bool) {
        
        topSeparatorView.isHidden = !isTitle
        
        leftSideLabel.text = isTitle ? leftName : "   \(leftName)"
        rightSideLabel.text = isTitle ? rightName : "   \(rightName)"
        
        leftSideLabel.font = isTitle ? UIFont.fontRobotoMedium(size: 13) : UIFont.fontRobotoRegular(size: 13)
        rightSideLabel.font = isTitle ? UIFont.fontRobotoMedium(size: 13) : UIFont.fontRobotoRegular(size: 13)
        
        if isTitle {
            premiumViewContainer.isHidden = true
        } else {
            if isOwn {
                premiumViewContainer.isHidden = true
            } else {
                premiumViewContainer.isHidden = UserInfo.sharedInstance.purchaseIsValid
            }
        }
    }
}
