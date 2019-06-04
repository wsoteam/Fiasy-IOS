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
    @IBOutlet weak var leftSideLabel: UILabel!
    @IBOutlet weak var rightSideLabel: UILabel!

    //MARK: - Interface -
    func fillView(leftName: String, rightName: String, isTitle: Bool) {
        leftSideLabel.text = leftName
        rightSideLabel.text = rightName
        
        leftSideLabel.font = isTitle ? UIFont.fontRobotoRegular(size: 14) : UIFont.fontRobotoLight(size: 12)
        rightSideLabel.font = isTitle ? UIFont.fontRobotoRegular(size: 14) : UIFont.fontRobotoLight(size: 12)
    }
}
