//
//  AddProductTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddProductTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomContainerView: UIView!
    
    //MARK: - Properties -
    private var indexCell: IndexPath?
    private var delegate: AddProductDelegate?
    
    // MARK: - Interface -
    func fillCell(indexCell: IndexPath, delegate: AddProductDelegate, barCode: String?) {
        self.indexCell = indexCell
        self.delegate = delegate
        bottomContainerView.isHidden = true
        
        nameTextField.tag = indexCell.row
        switch indexCell.row {
        case 0:
            titleLabel.text = "Марка/производитель"
            nameButton.isHidden = true
            cameraIconImageView.isHidden = true
            nameTextField.keyboardType = .default
        case 1:
            titleLabel.text = "Название продукта"
            nameButton.isHidden = true
            cameraIconImageView.isHidden = true
            nameTextField.keyboardType = .default
        case 2:
            titleLabel.text = "Штрих-код"
            nameButton.isHidden = false
            cameraIconImageView.isHidden = false
            nameTextField.keyboardType = .numberPad
            bottomContainerView.isHidden = false
            
            guard let code = barCode else { return }
            nameTextField.text = code
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 20
    }
    
    //MARK: - Action -
    @IBAction func nameClicked(_ sender: UIButton) {
        delegate?.showCodeReading()
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        delegate?.textChange(tag: sender.tag, text: nameTextField.text)
    }
    
    @IBAction func switchChangeClicked(_ sender: UISwitch) {
        delegate?.switchChangeValue(state: sender.isOn)
    }
}
