//
//  DishCreateFirstFooterView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/12/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class DishCreateFirstFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    static let height: CGFloat = 135.0
    private var delegate: DishCreateFirstScreenDelegate?
    
    // MARK: - Interface -
    func fillFooter(delegate: DishCreateFirstScreenDelegate, title: String) {
        self.delegate = delegate
        self.titleLabel.text = title
    }
    
    // MARK: - Action's -
    @IBAction func addIngreientClicked(_ sender: Any) {
        self.delegate?.showAddPortion()
    }
}
