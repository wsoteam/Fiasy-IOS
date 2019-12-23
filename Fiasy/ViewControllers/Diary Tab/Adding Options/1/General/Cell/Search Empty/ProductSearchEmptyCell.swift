//
//  ProductSearchEmptyCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProductSearchEmptyCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = LS(key: .TEXT_START_SEARCH).capitalizeFirst
    }
}
