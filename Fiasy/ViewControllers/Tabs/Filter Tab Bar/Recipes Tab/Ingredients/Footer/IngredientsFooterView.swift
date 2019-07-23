//
//  IngredientsFooterView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class IngredientsFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    static let height: CGFloat = 60.0
    private var delegate: AddTemplateDelegate?
    
    // MARK: - Interface -
    func fillFooter(delegate: AddTemplateDelegate, title: String) {
        self.delegate = delegate
        self.titleLabel.text = title
    }
    
    // MARK: - Action's -
    @IBAction func addIngreientClicked(_ sender: Any) {
        self.delegate?.showAddPortion()
    }
}
