//
//  HelpTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorLeading: NSLayoutConstraint!
    
    // MARK: - Interface -
    func fillCell(model: HelpModel, isLastCell: Bool) {
        separatorLeading.constant = isLastCell ? 20 : 0
        titleLabel.text = model.questionTitle
    }
}
