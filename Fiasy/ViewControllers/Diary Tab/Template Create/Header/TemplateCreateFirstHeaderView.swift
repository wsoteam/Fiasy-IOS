//
//  TemplateCreateFirstHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class TemplateCreateFirstHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    static let height: CGFloat = 75.0
}
