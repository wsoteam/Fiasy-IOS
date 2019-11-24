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
    
    //MARK: - Properties -
    //private var delegate: PremiumDisplayDelegate?

    // MARK: - Interface -
    func fillView(leftName: String, rightName: String, isTitle: Bool) {
        
        //self.delegate = delegate
        
        topSeparatorView.isHidden = !isTitle
        
        leftSideLabel.text = isTitle ? leftName : "   \(leftName)"
        rightSideLabel.text = isTitle ? rightName : "   \(rightName)"
        
        leftSideLabel.textColor = isTitle ? #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1) : #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        rightSideLabel.textColor = isTitle ? #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1) : #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        leftSideLabel.font = isTitle ? UIFont.sfProTextSemibold(size: 13) : UIFont.sfProTextRegular(size: 13)
        rightSideLabel.font = isTitle ? UIFont.sfProTextSemibold(size: 13) : UIFont.sfProTextRegular(size: 13)
        
        //if isTitle {
            //premiumViewContainer.isHidden = true
//        } else {
//            if isOwn {
//                premiumViewContainer.isHidden = true
//            } else {
//                premiumViewContainer.isHidden = UserInfo.sharedInstance.purchaseIsValid
//            }
//        }
    }
    
    // MARK: - Actions -
    @IBAction func premiumClicked(_ sender: Any) {
        //delegate?.showPremiumScreen()
    }
}
