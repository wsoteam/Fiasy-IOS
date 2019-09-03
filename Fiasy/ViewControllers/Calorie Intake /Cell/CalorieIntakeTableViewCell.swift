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
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var insertTextField: UITextField!
    
    // MARK: - Properties -
    private var delegate: CalorieIntakeDelegate?
    private var indexPath: IndexPath?
    
    // MARK: - Interface -
    func fillCell(indexCell: IndexPath, currentUser: User?, delegate: CalorieIntakeDelegate, target: Int, activity: CGFloat) {
        self.delegate = delegate
        self.indexPath = indexCell
        
        selectedButton.isHidden = true
        moreLabel.isHidden = true
        insertTextField.isHidden = false
        switch indexCell.row {
        case 0:
            insertTextField.tag = 0
            titleNameLabel.text = "Рост"
            insertTextField.keyboardType = .numberPad
            insertTextField.isEnabled = true
            if let height = currentUser?.height, height != 0 {
                insertTextField.text = "\(height)"
            }
        case 1:
            insertTextField.tag = 1
            titleNameLabel.text = "Вес"
            insertTextField.keyboardType = .decimalPad
            if let weight = currentUser?.weight, weight != 0 {
                insertTextField.text = "\(weight)"
            }
        case 2:
            insertTextField.tag = 2
            titleNameLabel.text = "Возраст"
            insertTextField.keyboardType = .numberPad
            if let age = currentUser?.age, age != 0 {
                insertTextField.text = "\(age)"
            }
        case 3:
            titleNameLabel.text = "Активность"
            insertTextField.isEnabled = false
            insertTextField.isHidden = true
            moreLabel.isHidden = false
            selectedButton.isHidden = false
            
            moreLabel.text = fetchActivity(value: activity)
        case 4:
            titleNameLabel.text = "Цель"
            insertTextField.isEnabled = false
            moreLabel.isHidden = false
            selectedButton.isHidden = false
            insertTextField.isHidden = true
            
            moreLabel.text = fetchTargetName(index: target)
        default:
            break
        }
    }
    
    private func fetchActivity(value: CGFloat) -> String {
        switch value {
        case 0.0:
            return "Минимальная нагрузка"
        case 1.0:
            return "Легкая физическая нагрузка\nв течении дня"
        case 2.0:
            return "Тренировки 2-4 раза в неделю\n(или работа средней тяжести)"
        case 3.0:
            return "Интенсивные тренировки\n4-5 раз в неделю"
        case 4.0:
            return "Ежедневные интенсивные\nтренировки"
        case 5.0:
            return "Тренировки 5-7 раз в неделю,\nпо два раза в день"
        case 6.0:
            return "Тяжелая физическая работа или\nежедневные интенсивные тренировки\nпо 2 раза в день"
        default:
            return ""
        }
    }
    
    private func fetchTargetName(index: Int) -> String {
        switch index {
        case 0:
            return "Поддержание тела в форме"
        case 1:
            return "Похудение"
        case 2:
            return "Набор мышечной массы"
        default:
            return "Сохранение мышц и сжигание жира"
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
        case 3:
            delegate?.showTarget()
        case 4:
            delegate?.showActivity()
        default:
            break
        }
    }
}
