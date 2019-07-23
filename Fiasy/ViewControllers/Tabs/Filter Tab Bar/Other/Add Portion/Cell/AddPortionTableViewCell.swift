//
//  AddPortionTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddPortionTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var delegate: AddPortionDelegate?
    
    // MARK: - Interface -
    func fillCell(index: Int, delegate: AddPortionDelegate) {
        self.delegate = delegate
        
        switch index {
        case 0:
            titleLabel.text = "Наименование порции"
            nameTextField.textColor = #colorLiteral(red: 0.1293928325, green: 0.1294226646, blue: 0.129390955, alpha: 1)
            nameTextField.text = ""
        case 1:
            titleLabel.text = "Единица измерения"
            nameTextField.textColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
            nameTextField.text = "Грамм"
        case 2:
            titleLabel.text = "Размер порции"
            nameTextField.textColor = #colorLiteral(red: 0.1293928325, green: 0.1294226646, blue: 0.129390955, alpha: 1)
            nameTextField.text = ""
        default:
            break
        }
        nameTextField.tag = index
        nameTextField.isEnabled = index != 1
        nameTextField.keyboardType = index == 0 ? .default : .numberPad
        
        if isIphone5 {
            topConstraint.constant = 10
            titleLabel.font = titleLabel.font.withSize(10)
            nameTextField.font = nameTextField.font?.withSize(12)
        }
    }
    
    // MARK: - Action -
    @IBAction func pickerClicked(_ sender: Any) {
        //
    }
    
    @IBAction func valueChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.delegate?.fillTextInfo(index: sender.tag, text: text)
    }
}
