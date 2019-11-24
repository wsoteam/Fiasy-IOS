//
//  RecipesSearchHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class RecipesSearchHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {

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
        guard let text = self.textField.text, text.isEmpty else { return }
        self.delegate?.searchItem(text: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        self.delegate?.searchItem(text: text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.changeScreenState(state: .search)
    }
}
