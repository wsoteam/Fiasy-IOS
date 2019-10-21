//
//  PremiumSecondSlideView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumSecondSlideView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var commentImageView: UIImageView!
    
    // MARK: - Interface -
    func fillView(index: Int) {
        switch index {
        case 0:
            commentImageView.image = #imageLiteral(resourceName: "Group 2 (7)")
        case 1:
            commentImageView.image = #imageLiteral(resourceName: "prem_22")
        case 2:
            commentImageView.image = #imageLiteral(resourceName: "prem_23")
        default:
            break
        }
    }
}
