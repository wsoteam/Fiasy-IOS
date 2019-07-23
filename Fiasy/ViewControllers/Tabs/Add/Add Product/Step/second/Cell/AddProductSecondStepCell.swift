//
//  AddProductSecondStepCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddProductSecondStepCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties -
    private var delegate: AddProductDelegate?
    
    // MARK: - Inteface -
    func fillCell(indexPath: IndexPath, delegate: AddProductDelegate) {
        self.delegate = delegate
        
        nameTextField.tag = indexPath.row
        nameTextField.keyboardType = .numberPad
        switch indexPath.row {
        case 0:
            titleLabel.text = "Калорийность (ккал)"
        case 1:
            titleLabel.text = "Жиры (г)"
        case 2:
            titleLabel.text = "Углеводы (г)"
        case 3:
            titleLabel.text = "Белки (г)"
        default:
            break
        }
    }
    
    func fillSecondCell(indexPath: IndexPath, delegate: AddProductDelegate) {
        self.delegate = delegate
        nameTextField.tag = indexPath.row
        nameTextField.keyboardType = .numberPad
        switch indexPath.row {
        case 0:
            titleLabel.text = "Клетчатка (г)"
        case 1:
            titleLabel.text = "Сахар (г)"
        case 2:
            titleLabel.text = "Насыщенные жиры (г)"
        case 3:
            titleLabel.text = "Мононенасыщенные жиры (г)"
        case 4:
            titleLabel.text = "Полиненасыщенные жиры (г)"
        case 5:
            titleLabel.text = "Холестерин (мг)"
        case 6:
            titleLabel.text = "Натрий (мг)"
        case 7:
            titleLabel.text = "Калий (мг)"
        default:
            break
        }
    }
    
    func fillCellByLastStep(indexPath: IndexPath, _ flow: AddProductFlow) {
        nameTextField.isEnabled = false
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                titleLabel.text = "Марка/производитель"
                nameTextField.text = flow.brend ?? "-"
            case 1:
                titleLabel.text = "Название продукта"
                nameTextField.text = flow.name ?? "-"
            case 2:
                titleLabel.text = "Штрих-код"
                nameTextField.text = flow.barCode ?? "-"
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                titleLabel.text = "Калорийность (ккал)"
                nameTextField.text = flow.calories ?? "-"
            case 1:
                titleLabel.text = "Жиры (г)"
                nameTextField.text = flow.fat ?? "-"
            case 2:
                titleLabel.text = "Углеводы (г)"
                nameTextField.text = flow.carbohydrates ?? "-"
            case 3:
                titleLabel.text = "Белки (г)"
                nameTextField.text = flow.protein ?? "-"
            case 4:
                titleLabel.text = "Клетчатка (г)"
                nameTextField.text = flow.cellulose ?? "-"
            case 5:
                titleLabel.text = "Сахар (мг)"
                nameTextField.text = flow.sugar ?? "-"
            case 6:
                titleLabel.text = "Насыщенные жиры (г)"
                nameTextField.text = flow.saturatedFats ?? "-"
            case 7:
                titleLabel.text = "Мононенасыщенные жиры (г)"
                nameTextField.text = flow.monounsaturatedFats ?? "-"
            case 8:
                titleLabel.text = "Полиненасыщенные жиры (г)"
                nameTextField.text = flow.polyunsaturatedFats ?? "-"
            case 9:
                titleLabel.text = "Холестерин (мг)"
                nameTextField.text = flow.cholesterol ?? "-"
            case 10:
                titleLabel.text = "Натрий (мг)"
                nameTextField.text = flow.sodium ?? "-"
            case 11:
                titleLabel.text = "Калий (мг)"
                nameTextField.text = flow.potassium ?? "-"
            default:
                break
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func textChange(_ sender: UITextField) {
        delegate?.textChange(tag: sender.tag, text: nameTextField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
}
