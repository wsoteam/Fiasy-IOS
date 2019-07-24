//
//  AddTemplateHeaderCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddTemplateHeaderCell: UITableViewCell {
    
    // MARK: - Properties -
    @IBOutlet weak var nameTextField: UITextField!
    private var delegate: AddTemplateDelegate?
    
    // MARK: - Interface -
    func fillCell(by delegate: AddTemplateDelegate, selectedTemplate: Template?, name: String) {
        self.delegate = delegate
        
        if !name.isEmpty {
            nameTextField.text = name
        } else {
            nameTextField.text = selectedTemplate?.name
        }
    }
    
    // MARK: - Action -
    @IBAction func valueChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.delegate?.fillTemplateTitle(text: text)
    }
}
