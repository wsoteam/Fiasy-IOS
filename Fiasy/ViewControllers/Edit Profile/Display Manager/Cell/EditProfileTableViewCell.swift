//
//  EditProfileTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var insertTextField: UITextField!
    
    // MARK: - Properties -
    private var delegate: EditProfileDisplayDelegate?
    
    // MARK: - Interface -
    func fillCell(indexCell: IndexPath, currentUser: User, delegate: EditProfileDisplayDelegate) {
        self.delegate = delegate
        
        insertTextField.tag = indexCell.row
        switch indexCell.row {
        case 0:
            titleNameLabel.text = "Имя"
            insertTextField.keyboardType = .default
            if let name = currentUser.firstName, !name.isEmpty && name != "default" {
                insertTextField.text = name
            }
        case 1:
            titleNameLabel.text = "Фамилия"
            insertTextField.keyboardType = .default
            if let name = currentUser.lastName, !name.isEmpty && name != "default" {
                insertTextField.text = name
            }
        case 2:
            titleNameLabel.text = "Почта"
            insertTextField.keyboardType = .emailAddress
            if let email = currentUser.email, !email.isEmpty && email != "default" {
                insertTextField.text = email
            }
        case 3:
            titleNameLabel.text = "Возраст"
            insertTextField.keyboardType = .numberPad
            if let age = currentUser.age, age != 0 {
                insertTextField.text = "\(age)"
            }
        case 4:
            titleNameLabel.text = "Вес"
            insertTextField.keyboardType = .decimalPad
            if let weight = currentUser.weight, weight != 0 {
                insertTextField.text = "\(weight)"
            }
        case 5:
            titleNameLabel.text = "Рост"
            insertTextField.keyboardType = .numberPad
            if let height = currentUser.height, height != 0 {
                insertTextField.text = "\(height)"
            }
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
        
        if textField.tag == 4 {
            if textFieldText.contains(",") {
                if string == "," {
                    return false
                } else {
                    if let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                        let array = updatedString.components(separatedBy: ",")
                        if array.indices.contains(1) {
                            if array[1].count >= 2 {
                                return false
                            }
                        }
                    }
                }
            }
            if textFieldText.contains(".") {
                if string == "." {
                    return false
                } else {
                    if let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                        let array = updatedString.components(separatedBy: ".")
                        if array.indices.contains(1) {
                            if array[1].count >= 2 {
                                return false
                            }
                        }
                    }
                }
            }
          return count <= 5
        }
        if textField.tag == 3 || textField.tag == 5 {
            return count <= 3
        } else {
            return string == " " ? false : count <= (textField.tag == 2 ? 100 : 30)
        }
    }
    
    // MARK: - Actions -
    @IBAction func valueChange(_ sender: UITextField) {
        guard let text = insertTextField.text else { return }
        delegate?.fillField(by: sender.tag, text: text)
    }
}
