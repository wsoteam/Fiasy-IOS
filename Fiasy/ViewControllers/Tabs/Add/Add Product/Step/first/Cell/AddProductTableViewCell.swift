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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var typeProductTitleLabel: UILabel!
    @IBOutlet var stateProductLabels: [UILabel]!
    @IBOutlet var stateProductImages: [UIImageView]!
    @IBOutlet weak var middleContainerView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomContainerView: UIView!
    
    // MARK: - Properties -
    private var indexCell: IndexPath?
    private var delegate: AddProductDelegate?
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stateProductLabels[0].text = LS(key: .CREATE_STEP_TITLE_10)
        stateProductLabels[1].text = LS(key: .CREATE_STEP_TITLE_11)
        typeProductTitleLabel.text = LS(key: .CREATE_STEP_TITLE_7)
        errorLabel.text = LS(key: .CREATE_STEP_TITLE_12)
        nextButton.setTitle("\(LS(key: .UNBOARDING_NEXT)) ", for: .normal)
        changeProductType(productType: UserInfo.sharedInstance.productFlow.productType)
    }
    
    // MARK: - Interface -
    func fillCell(indexCell: IndexPath, delegate: AddProductDelegate, barCode: String?, _ selectedFavorite: Favorite?) {
        self.indexCell = indexCell
        self.delegate = delegate
        
        middleContainerView.isHidden = true
        nameTextField.tag = indexCell.row
        switch indexCell.row {
        case 0:
            titleLabel.text = LS(key: .CREATE_STEP_TITLE_4)
            nameButton.isHidden = true
            cameraIconImageView.isHidden = true
            nameTextField.keyboardType = .default
            if let selected = selectedFavorite {
                nameTextField.text = selected.brand
            }
            nameTextField.tag = 0
        case 1:
            titleLabel.text = LS(key: .CREATE_STEP_TITLE_5)
            nameButton.isHidden = true
            cameraIconImageView.isHidden = true
            nameTextField.keyboardType = .default
            if let selected = selectedFavorite {
                nameTextField.text = selected.name
            }
            nameTextField.tag = 1
        case 2:
            fillDescription()
            middleContainerView.isHidden = false
            titleLabel.text = LS(key: .CREATE_STEP_TITLE_6)
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
            nameTextField.tag = 2
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        errorLabel.isHidden = true
        separatorView.backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return textField.tag == 2 ? count <= 20 : count <= 30
    }
    
    // MARK: - Private -
    private func fillDescription() {
        let mutableAttrString = NSMutableAttributedString(string: descriptionLabel.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        descriptionLabel.attributedText = mutableAttrString
    }
    
    private func changeProductType(productType: TypeProduct) {
        switch productType {
        case .product:
            typeProductTitleLabel.text = LS(key: .CREATE_STEP_TITLE_7)
            stateProductLabels[0].alpha = 1.0
            stateProductLabels[1].alpha = 0.5
            
            stateProductImages[0].alpha = 1.0
            stateProductImages[1].alpha = 0.5
        default:
            typeProductTitleLabel.text = LS(key: .CREATE_STEP_TITLE_8)
            stateProductLabels[0].alpha = 0.5
            stateProductLabels[1].alpha = 1.0
            
            stateProductImages[0].alpha = 0.5
            stateProductImages[1].alpha = 1.0
        }
    }

    //MARK: - Action -
    @IBAction func nameClicked(_ sender: UIButton) {
        delegate?.showCodeReading()
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        delegate?.textChange(tag: sender.tag, text: nameTextField.text)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        delegate?.nextStepClicked()
    }
    
    @IBAction func switchChangeClicked(_ sender: UISwitch) {
        //delegate?.switchChangeValue(state: sender.isOn)
    }
    
    @IBAction func stateProductClicked(_ sender: UIButton) {
        UserInfo.sharedInstance.productFlow.productType = TypeProduct(rawValue: sender.tag) ?? .product
        changeProductType(productType: UserInfo.sharedInstance.productFlow.productType)
    }
}
