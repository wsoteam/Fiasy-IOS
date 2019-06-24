//
//  RecipesSearchHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class RecipesSearchHeaderView: UITableViewHeaderFooterView {

    //MARK: - Outlet -
    @IBOutlet weak var textField: DesignableUITextField!
    
    //MARK: - Properties -
    static let height: CGFloat = 60.0
    private var delegate: RecipesSearchDelegate?
    
    //MARK: - Interface -
    func fillHeader(delegate: RecipesSearchDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - Action -
    @IBAction func valueChange(_ sender: Any) {
        guard let text = self.textField.text else { return }
        self.delegate?.searchItem(text: text)
    }
}