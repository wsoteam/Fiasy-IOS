//
//  CalorieIntakePremiumCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 9/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class CalorieIntakePremiumCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var mifinLabel: UILabel!
    @IBOutlet var allTextFields: [UITextField]!
    
    // MARK: - Properties -
    private var fat: Int?
    private var protein: Int?
    private var calories: Int?
    private var carbohydrates: Int?
    private var indexPath: IndexPath?
    private var delegate: CalorieIntakeDelegate?
    private var defaultData: [Int] = [0, 0, 0, 0]
    
    // MARK: - Interface -
    func fillCell(_ indexCell: IndexPath, _ currentUser: User?, _ delegate: CalorieIntakeDelegate, _ purchaseIsValid: Bool, _ defaultData: [Int], _ allPremiumFields: [String]) {
        self.delegate = delegate
        self.indexPath = indexCell
        self.defaultData = defaultData
        
        if self.fat == nil {
            self.fat = currentUser?.maxFat
        }
        if self.carbohydrates == nil {
            self.carbohydrates = currentUser?.maxCarbo
        }
        if self.calories == nil {
            self.calories = currentUser?.maxKcal
        }
        if self.protein == nil {
            self.protein = currentUser?.maxProt
        }
        
        if defaultData[0] == self.calories && defaultData[1] == self.protein && defaultData[2] == self.carbohydrates && defaultData[3] == self.fat {
            mifinLabel.isHidden = false
            defaultButton.isUserInteractionEnabled = false
            defaultButton.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
        } else {
            mifinLabel.isHidden = true
            defaultButton.isUserInteractionEnabled = true
            defaultButton.backgroundColor = #colorLiteral(red: 1, green: 0.5934835672, blue: 0.1931354403, alpha: 1)
        }

        if let calories = self.calories {
            allTextFields[0].text = "\(calories)"
        } else {
            allTextFields[0].text?.removeAll()
        }
        
        if let protein = self.protein {
            allTextFields[1].text = "\(protein)"
        } else {
            allTextFields[1].text?.removeAll()
        }
        
        if let carbohydrates = self.carbohydrates {
            allTextFields[2].text = "\(carbohydrates)"
        } else {
            allTextFields[2].text?.removeAll()
        }
        
        if let maxFat = self.fat {
            allTextFields[3].text = "\(maxFat)"
        } else {
            allTextFields[3].text?.removeAll()
        }
        for field in allTextFields {
            field.isEnabled = purchaseIsValid
        }

        if !allPremiumFields.isEmpty && allPremiumFields.count == 4 {
            allTextFields[0].text = allPremiumFields[0]
            allTextFields[1].text = allPremiumFields[1]
            allTextFields[2].text = allPremiumFields[2]
            allTextFields[3].text = allPremiumFields[3]
        }
    }
    
    // MARK: - Actions -
    @IBAction func defaultClicked(_ sender: Any) {
        allTextFields[0].text = "\(defaultData[0])"
        allTextFields[1].text = "\(defaultData[1])"
        allTextFields[2].text = "\(defaultData[2])"
        allTextFields[3].text = "\(defaultData[3])"
        
        mifinLabel.isHidden = false
        defaultButton.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
        defaultButton.isUserInteractionEnabled = false
        delegate?.reloadTable(allText: [allTextFields[0].text ?? "", allTextFields[1].text ?? "", allTextFields[2].text ?? "", allTextFields[3].text ?? ""])
    }
    
    // MARK: - Actions -
    @IBAction func valueChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
    
        if sender.tag == 999 {
            let someCalories: Int = Int("\(text)") ?? 0
            self.calories = someCalories
            self.protein = Int(((Double(someCalories) * 0.4)/4).displayOnly(count: 0))
            self.carbohydrates = Int(((Double(someCalories) * 0.35)/4).displayOnly(count: 0))
            self.fat = Int(((Double(someCalories) * 0.4)/25).displayOnly(count: 0))
            
            allTextFields[1].text = "\(self.protein ?? 0)"
            allTextFields[2].text = "\(self.carbohydrates ?? 0)"
            allTextFields[3].text = "\(self.fat ?? 0)"
            
            if defaultData[0] == self.calories && defaultData[1] == self.protein && defaultData[2] == self.carbohydrates && defaultData[3] == self.fat {
                mifinLabel.isHidden = false
                
                defaultButton.isUserInteractionEnabled = false
                defaultButton.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            } else {
                mifinLabel.isHidden = true
                
                defaultButton.isUserInteractionEnabled = true
                defaultButton.backgroundColor = #colorLiteral(red: 1, green: 0.5934835672, blue: 0.1931354403, alpha: 1)
            }
            delegate?.reloadTable(allText: [allTextFields[0].text ?? "", allTextFields[1].text ?? "", allTextFields[2].text ?? "", allTextFields[3].text ?? ""])
        } else {
            if defaultData[0] == Int("\(allTextFields[0].text ?? "0")") && defaultData[1] == Int("\(allTextFields[1].text ?? "0")") && defaultData[2] == Int("\(allTextFields[2].text ?? "0")") && defaultData[3] == Int("\(allTextFields[3].text ?? "0")") {
                mifinLabel.isHidden = false
                
                defaultButton.isUserInteractionEnabled = false
                defaultButton.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            } else {
                mifinLabel.isHidden = true
                
                defaultButton.isUserInteractionEnabled = true
                defaultButton.backgroundColor = #colorLiteral(red: 1, green: 0.5934835672, blue: 0.1931354403, alpha: 1)
            }
            delegate?.reloadTable(allText: [allTextFields[0].text ?? "", allTextFields[1].text ?? "", allTextFields[2].text ?? "", allTextFields[3].text ?? ""])
        }
    }
}

extension CalorieIntakePremiumCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
}
