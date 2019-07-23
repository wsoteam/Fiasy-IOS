//
//  AddProductFooterTableView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddProductFooterTableView: UITableViewHeaderFooterView {

    // MARK: - Properties -
    static var height: CGFloat = 150.0
    private var delegate: AddProductDelegate?
    
    // MARK: - Interface -
    func fillFooter(delegate: AddProductDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Actions -
    @IBAction func nextStepClicked(_ sender: Any) {
        self.delegate?.nextStepClicked()
    }
}
