//
//  ServingSizeHeaderCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ServingSizeHeaderCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = LS(key: .CREATE_STEP_TITLE_15)
    }
}
