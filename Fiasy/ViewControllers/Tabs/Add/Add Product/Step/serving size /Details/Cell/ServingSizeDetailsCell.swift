//
//  ServingSizeDetailsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ServingSizeDetailsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var clickedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var insertTextField: UITextField!
    
    // MARK: - Properties -
    private var delegate: ServingSizeDetailsDelegate?
    
    // MARK: - Interface -
    func fillCell(indexPath: IndexPath, _ selectedServing: Serving, _ delegate: ServingSizeDetailsDelegate) {
        self.delegate = delegate
        insertTextField.isEnabled = true
        clickedButton.isHidden = true
        errorLabel.alpha = 0
        switch indexPath.row {
        case 0:
            insertTextField.textColor = #colorLiteral(red: 0.1293928325, green: 0.1294226646, blue: 0.129390955, alpha: 1)
            titleLabel.text = LS(key: .CREATE_STEP_TITLE_23)
            insertTextField.text = selectedServing.name ?? ""
            insertTextField.keyboardType = .default
            insertTextField.tag = 0
            errorLabel.text = LS(key: .CREATE_STEP_TITLE_24)
        case 1:
            clickedButton.isHidden = false
            insertTextField.isEnabled = false
            insertTextField.textColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 0.5047338453)
            titleLabel.text = LS(key: .CREATE_STEP_TITLE_25)
            errorLabel.text = ""
            insertTextField.tag = 1
            if let measurement = selectedServing.unitMeasurement, !measurement.isEmpty {
                insertTextField.text = measurement
            } else {
                insertTextField.text = LS(key: .CREATE_STEP_TITLE_19)
            }
        case 2:
            insertTextField.textColor = #colorLiteral(red: 0.1293928325, green: 0.1294226646, blue: 0.129390955, alpha: 1)
            titleLabel.text = LS(key: .CREATE_STEP_TITLE_26)
            errorLabel.text = LS(key: .CREATE_STEP_TITLE_27)
            insertTextField.tag = 2
            if let size = selectedServing.servingSize, size != 0 {
                insertTextField.text = "\(size)"
            } else {
                insertTextField.text = ""
            }
            insertTextField.keyboardType = .numberPad
        default:
            break
        }
    }
    
    func updateServingUnit(text: String) {
        insertTextField.text = text
    }
    
    // MARK: - Actions -
    @IBAction func fieldChanged(_ sender: UITextField) {
        delegate?.textChange(tag: sender.tag, text: insertTextField.text)
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        delegate?.openPicker()
    }
}

extension ServingSizeDetailsCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        errorLabel.alpha = 0
        separatorView.backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= (textField.tag == 2 ? 5 : 30)
    }
}
