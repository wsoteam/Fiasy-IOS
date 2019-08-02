//
//  EditProfileTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    
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
            insertTextField.keyboardType = .numberPad
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
    
    // MARK: - Actions -
    @IBAction func valueChange(_ sender: UITextField) {
        guard let text = insertTextField.text else { return }
        delegate?.fillField(by: sender.tag, text: text)
    }
}
