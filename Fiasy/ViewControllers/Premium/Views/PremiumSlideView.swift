//
//  PremiumSlideView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumSlideView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isIphone5 {
            titleLabel.font = titleLabel.font.withSize(15)
        }
    }
}
