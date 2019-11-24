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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties -
    private var delegate: AddProductDelegate?
    
    // MARK: - Inteface -
    func fillCell(indexPath: IndexPath, delegate: AddProductDelegate, flow: AddProductFlow) {
        self.delegate = delegate
        
        nameTextField.tag = indexPath.row
        nameTextField.keyboardType = .decimalPad
        
        switch indexPath.row {
        case 0:
            nameTextField.tag = 0
            errorLabel.text = "Введите калорийность продукта"
            titleLabel.text = "Калорийность (ккал)"
            if let calories = flow.calories {
                nameTextField.text = calories
            } else {
                nameTextField.text?.removeAll()
            }
        case 1:
            nameTextField.tag = 1
            errorLabel.text = "Введите жиры продукта"
            titleLabel.text = "Жиры (г)"
            if let fats = flow.fat {
                nameTextField.text = fats
            } else {
                nameTextField.text?.removeAll()
            }
        case 2:
            nameTextField.tag = 2
            errorLabel.text = "Введите углеводы продукта"
            titleLabel.text = "Углеводы (г)"
            if let carbohydrates = flow.carbohydrates {
                nameTextField.text = carbohydrates
            } else {
                nameTextField.text?.removeAll()
            }
        case 3:
            nameTextField.tag = 3
            errorLabel.text = "Введите белки продукта"
            titleLabel.text = "Белки (г)"
            if let proteins = flow.protein {
                nameTextField.text = proteins
            } else {
                nameTextField.text?.removeAll()
            }
        default:
            break
        }
    }
    
    func fillSecondCell(indexPath: IndexPath, delegate: AddProductDelegate, _ flow: AddProductFlow) {
        self.delegate = delegate
        nameTextField.tag = indexPath.row
        nameTextField.keyboardType = .decimalPad
        switch indexPath.row {
        case 0:
            titleLabel.text = "Клетчатка (г)"
            if let cellulose = flow.cellulose {
                nameTextField.text = cellulose
            } else {
                nameTextField.text?.removeAll()
            }
        case 1:
            titleLabel.text = "Сахар (г)"
            if let sugar = flow.sugar {
                nameTextField.text = sugar
            } else {
                nameTextField.text?.removeAll()
            }
        case 2:
            titleLabel.text = "Насыщенные жиры (г)"
            if let saturatedFats = flow.saturatedFats {
                nameTextField.text = saturatedFats
            } else {
                nameTextField.text?.removeAll()
            }
        case 3:
            titleLabel.text = "Мононенасыщенные жиры (г)"
            if let monoUnSaturatedFats = flow.monounsaturatedFats {
                nameTextField.text = monoUnSaturatedFats
            } else {
                nameTextField.text?.removeAll()
            }
        case 4:
            titleLabel.text = "Полиненасыщенные жиры (г)"
            if let polyUnSaturatedFats = flow.polyunsaturatedFats {
                nameTextField.text = polyUnSaturatedFats
            } else {
                nameTextField.text?.removeAll()
            }
        case 5:
            titleLabel.text = "Холестерин (мг)"
            if let cholesterol = flow.cholesterol {
                nameTextField.text = cholesterol
            } else {
                nameTextField.text?.removeAll()
            }
        case 6:
            titleLabel.text = "Натрий (мг)"
            if let sodium = flow.sodium {
                nameTextField.text = sodium
            } else {
                nameTextField.text?.removeAll()
            }
        case 7:
            titleLabel.text = "Калий (мг)"
            if let pottassium = flow.potassium {
                nameTextField.text = pottassium
            } else {
                nameTextField.text?.removeAll()
            }
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
                var text: String = ""
                let fullNameArr = (flow.brend ?? "").split{$0 == " "}.map(String.init)
                for item in fullNameArr where !item.isEmpty {
                    text = text.isEmpty ? item : text + " \(item)"
                }
                nameTextField.text = text.isEmpty ? "-" : text
            case 1:
                titleLabel.text = "Название продукта"
                var text: String = ""
                let fullNameArr = (flow.name ?? "").split{$0 == " "}.map(String.init)
                for item in fullNameArr where !item.isEmpty {
                    text = text.isEmpty ? item : text + " \(item)"
                }
                nameTextField.text = text.isEmpty ? "-" : text
            case 2:
                titleLabel.text = "Штрих-код"
                if let barCode = flow.barCode, !barCode.isEmpty {
                    nameTextField.text = barCode
                } else {
                    nameTextField.text = "-"
                }
            default:
                if flow.allServingSize.indices.contains(indexPath.row - 3) {
                    let serving = flow.allServingSize[indexPath.row - 3]
                    titleLabel.text = serving.name
                    if let cher = "\(serving.unitMeasurement ?? "")".lowercased().first {
                        nameTextField.text = "\(serving.servingSize ?? 0) \(String(cher))."
                    } else {
                        nameTextField.text = ""
                    }
                }
            }
        } else {
            switch indexPath.row {
            case 0:
                titleLabel.text = "Калорийность (ккал)"
                if let calories = flow.calories, !calories.isEmpty {
                    if calories.contains(".") {
                        var fullNameArr = calories.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if calories.contains(",") {
                        var fullNameArr = calories.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(calories) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 1:
                titleLabel.text = "Жиры (г)"
                if let fat = flow.fat, !fat.isEmpty {
                    if fat.contains(".") {
                        var fullNameArr = fat.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if fat.contains(",") {
                        var fullNameArr = fat.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(fat) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 2:
                titleLabel.text = "Углеводы (г)"
                if let carbohydrates = flow.carbohydrates, !carbohydrates.isEmpty {
                    if carbohydrates.contains(".") {
                        var fullNameArr = carbohydrates.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if carbohydrates.contains(",") {
                        var fullNameArr = carbohydrates.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(carbohydrates) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 3:
                titleLabel.text = "Белки (г)"
                if let protein = flow.protein, !protein.isEmpty {
                    if protein.contains(".") {
                        var fullNameArr = protein.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if protein.contains(",") {
                        var fullNameArr = protein.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(protein) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 4:
                titleLabel.text = "Клетчатка (г)"
                if let cellulose = flow.cellulose, !cellulose.isEmpty {
                    if cellulose.contains(".") {
                        var fullNameArr = cellulose.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if cellulose.contains(",") {
                        var fullNameArr = cellulose.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(cellulose) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 5:
                titleLabel.text = "Сахар (мг)"
                if let sugar = flow.sugar, !sugar.isEmpty {
                    if sugar.contains(".") {
                        var fullNameArr = sugar.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if sugar.contains(",") {
                        var fullNameArr = sugar.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(sugar) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 6:
                titleLabel.text = "Насыщенные жиры (г)"
                if let saturatedFats = flow.saturatedFats, !saturatedFats.isEmpty {
                    if saturatedFats.contains(".") {
                        var fullNameArr = saturatedFats.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if saturatedFats.contains(",") {
                        var fullNameArr = saturatedFats.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(saturatedFats) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 7:
                titleLabel.text = "Мононенасыщенные жиры (г)"
                if let monounsaturatedFats = flow.monounsaturatedFats, !monounsaturatedFats.isEmpty {
                    if monounsaturatedFats.contains(".") {
                        var fullNameArr = monounsaturatedFats.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if monounsaturatedFats.contains(",") {
                        var fullNameArr = monounsaturatedFats.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(monounsaturatedFats) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 8:
                titleLabel.text = "Полиненасыщенные жиры (г)"
                if let polyunsaturatedFats = flow.polyunsaturatedFats, !polyunsaturatedFats.isEmpty {
                    if polyunsaturatedFats.contains(".") {
                        var fullNameArr = polyunsaturatedFats.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if polyunsaturatedFats.contains(",") {
                        var fullNameArr = polyunsaturatedFats.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(polyunsaturatedFats) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 9:
                titleLabel.text = "Холестерин (мг)"
                if let cholesterol = flow.cholesterol, !cholesterol.isEmpty {
                    if cholesterol.contains(".") {
                        var fullNameArr = cholesterol.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if cholesterol.contains(",") {
                        var fullNameArr = cholesterol.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(cholesterol) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 10:
                titleLabel.text = "Натрий (мг)"
                if let sodium = flow.sodium, !sodium.isEmpty {
                    if sodium.contains(".") {
                        var fullNameArr = sodium.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if sodium.contains(",") {
                        var fullNameArr = sodium.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(sodium) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            case 11:
                titleLabel.text = "Калий (мг)"
                if let potassium = flow.potassium, !potassium.isEmpty {
                    if potassium.contains(".") {
                        var fullNameArr = potassium.components(separatedBy: ".")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0).\(fullNameArr[1])"
                    } else if potassium.contains(",") {
                        var fullNameArr = potassium.components(separatedBy: ",")
                        nameTextField.text = "\(Int(fullNameArr[0]) ?? 0),\(fullNameArr[1])"
                    } else {
                        nameTextField.text = "\(Int(potassium) ?? 0)"
                    }
                } else {
                    nameTextField.text = "-"
                }
            default:
                break
            }
        }
    }
    
    func fillCellByCreateRecipe(flow: AddRecipeFlow, index: Int) {
        nameTextField.isEnabled = false
        
        switch index {
        case 0:
            titleLabel.text = "Название рецепта"
    
            var recipeName: String = ""
            let fullNameArr = (flow.recipeName ?? "").split{$0 == " "}.map(String.init)
            for item in fullNameArr where !item.isEmpty {
                recipeName = recipeName.isEmpty ? item : recipeName + " \(item)"
            }
            nameTextField.text = recipeName
        case 1:
            titleLabel.text = "Время приготовления"
            nameTextField.text = "\(flow.time ?? "") мин."
        case 2:
            titleLabel.text = "Сложность"
            nameTextField.text = flow.complexity
        default:
            break
        }
    }
    
    // MARK: - Private -

    // MARK: - Actions -
    @IBAction func textChange(_ sender: UITextField) {
        delegate?.textChange(tag: sender.tag, text: nameTextField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        errorLabel.isHidden = true
        separatorView.backgroundColor = #colorLiteral(red: 0.9293106198, green: 0.9294700027, blue: 0.9293007255, alpha: 1)
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textFieldText.contains(",") {
            if string == "," {
                return false
            } else {
                if let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                    let array = updatedString.components(separatedBy: ",")
                    if array.indices.contains(1) {
                        if array[1].count >= 3 {
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
                        if array[1].count >= 3 {
                            return false
                        }
                    }
                }
            }
        }
        return count <= 10
    }
}
