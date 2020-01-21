//
//  BasketHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class BasketHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    static let height: CGFloat = 60.0
    
    // MARK: - Interface -
    func fillHeader(by title: String) {
        titleLabel.text = title
    }
}
