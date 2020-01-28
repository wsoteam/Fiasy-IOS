//
//  TemplateCreateFirstCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class TemplateCreateFirstCell: UITableViewCell {
    
    // MARK: - Properties -
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    private var delegate: TemplateCreateDelegate?
    
    // MARK: - Interface -
    func fillCell(delegate: TemplateCreateDelegate, _ template: Template?) {
        self.delegate = delegate
        
        if let name = template?.name {
            nameTextField.text = name
        }
    }
    
    // MARK: - Actions -
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        UserInfo.sharedInstance.templateName = text
        self.delegate?.activeFinishButton(text.isEmpty)
    }
}
