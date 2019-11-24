//
//  CalorieIntakeTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/28/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class CalorieIntakeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var separatorInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var insertTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Properties -
    private var fat: Int?
    private var protein: Int?
    private var calories: Int?
    private var carbohydrates: Int?
    private var indexPath: IndexPath?
    private var delegate: CalorieIntakeDelegate?
    
    // MARK: - Interface -
    func fillCell(indexCell: IndexPath, currentUser: User?, delegate: CalorieIntakeDelegate, target: Int, activity: CGFloat, _ allField: [String]) {
        self.delegate = delegate
        self.indexPath = indexCell
        
        selectedButton.isHidden = true
        moreLabel.isHidden = true
        insertTextField.isHidden = false
        separatorView.isHidden = false
        insertTextField.textColor = #colorLiteral(red: 0.4038744569, green: 0.4039486647, blue: 0.4038697779, alpha: 1)
        insertTextField.isEnabled = true
        separatorInsetConstraint.constant = 15
        
        switch indexCell.row {
        case 0:
            insertTextField.tag = 44
            titleNameLabel.text = LS(key: .GENDER)
            insertTextField.keyboardType = .numberPad
            insertTextField.isEnabled = false
            insertTextField.textColor = #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
            if let female = currentUser?.female {
                insertTextField.text = female == true ? LS(key: .SEX_FEMALE) : LS(key: .SEX_MALE)
            }
        case 1:
            insertTextField.tag = 0
            titleNameLabel.text = LS(key: .GROWTH)
            insertTextField.keyboardType = .numberPad
            insertTextField.text = allField[0]
        case 2:
            insertTextField.tag = 1
            titleNameLabel.text = LS(key: .WEIGHT)
            insertTextField.keyboardType = .decimalPad
            insertTextField.text = allField[1]
        case 3:
            insertTextField.tag = 2
            titleNameLabel.text = LS(key: .AGE)
            insertTextField.keyboardType = .numberPad
            insertTextField.text = allField[2]
        case 4:
            titleNameLabel.text = LS(key: .ACTIVITY)
            insertTextField.isEnabled = false
            insertTextField.isHidden = true
            moreLabel.isHidden = false
            selectedButton.isHidden = false
            
            moreLabel.text = fetchActivity(value: activity)
        case 5:
            titleNameLabel.text = LS(key: .TARGET)
            insertTextField.isEnabled = false
            moreLabel.isHidden = false
            selectedButton.isHidden = false
            insertTextField.isHidden = true
            
            moreLabel.text = fetchTargetName(index: target)
            separatorInsetConstraint.constant = 0
            separatorView.isHidden = true
        default:
            break
        }
    }
    
    // MARK: - Private -
    private func fetchActivity(value: CGFloat) -> String {
        switch value {
        case 0.0:
            return LS(key: .FIRST_ACTIVITY)
        case 1.0:
            return LS(key: .SECOND_ACTIVITY)
        case 2.0:
            return LS(key: .THIRD_ACTIVITY)
        case 3.0:
            return LS(key: .FOURTH_ACTIVITY)
        case 4.0:
            return LS(key: .FIVE_ACTIVITY)
        case 5.0:
            return LS(key: .SIX_ACTIVITY)
        case 6.0:
            return LS(key: .SEVEN_ACTIVITY)
        default:
            return ""
        }
    }
    
    private func fetchTargetName(index: Int) -> String {
        switch index {
        case 0:
            return LS(key: .FIRST_TARGET)
        case 1:
            return LS(key: .SECOND_TARGET)
        case 2:
            return LS(key: .THIRD_TARGET)
        default:
            return LS(key: .FOURTH_TARGET)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField.tag == 1 {
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
        return count <= (textField.tag == 1 ? 5 : 3)
    }
    
    // MARK: - Actions -
    @IBAction func valueChange(_ sender: UITextField) {
        guard let text = insertTextField.text else { return }
        
        delegate?.fillField(by: sender.tag, text: text)
    }
    
    @IBAction func selectedButton(_ sender: Any) {
        guard let index = self.indexPath else { return }
        switch index.row {
        case 4:
            delegate?.showTarget()
        case 5:
            delegate?.showActivity()
        default:
            break
        }
    }
}
