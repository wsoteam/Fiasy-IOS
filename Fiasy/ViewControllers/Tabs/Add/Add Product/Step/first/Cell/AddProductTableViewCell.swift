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
    func fillCell(indexCell: IndexPath, delegate: AddProductDelegate, barCode: String?, _ selectedFavorite: Favorite?) {
        self.indexCell = indexCell
        self.delegate = delegate
        
        nameTextField.tag = indexCell.row
        switch indexCell.row {
        case 0:
            titleLabel.text = "Марка/производитель"
            nameButton.isHidden = true
            cameraIconImageView.isHidden = true
            nameTextField.keyboardType = .default
            if let selected = selectedFavorite {
                nameTextField.text = selected.brand
            }
        case 1:
            fillNecessarilyField(label: titleLabel, text: "Название продукта")
            nameButton.isHidden = true
            cameraIconImageView.isHidden = true
            nameTextField.keyboardType = .default
            if let selected = selectedFavorite {
                nameTextField.text = selected.name
            }
        case 2:
            titleLabel.text = "Штрих-код"
            nameButton.isHidden = false
            cameraIconImageView.isHidden = false
            nameTextField.keyboardType = .numberPad
            if let _ = selectedFavorite {
                bottomContainerView.isHidden = true
            } else {
                bottomContainerView.isHidden = false
            }
            if let selected = selectedFavorite {
                nameTextField.text = selected.barcode
            }
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
    
    // MARK: - Private -
    private func fillNecessarilyField(label: UILabel, text: String) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 15.0),
                                              color: #colorLiteral(red: 0.6548290849, green: 0.654943943, blue: 0.6548218727, alpha: 1), text: text))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 15.0),
                                                     color: #colorLiteral(red: 0.8957664371, green: 0.2344577312, blue: 0.1905975044, alpha: 1), text: " *"))
        
        label.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
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
