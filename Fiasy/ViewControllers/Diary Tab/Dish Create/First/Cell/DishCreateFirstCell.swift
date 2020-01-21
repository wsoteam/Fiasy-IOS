//
//  DishCreateFirstCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/9/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown

class DishCreateFirstCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var fixedView: UIView!
    @IBOutlet weak var resizeView: UIView!
    @IBOutlet weak var selectedStackView: UIStackView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: - Properties -
    private var tableView: UITableView?
    private var delegate: DishCreateFirstScreenDelegate?
    
    // MARK: - Interface -
    func fillCell(_ tableView: UITableView, _ selectedImage: UIImage?, _ dish: Dish?, _ delegate: DishCreateFirstScreenDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        
        if let name = dish?.name {
            nameTextView.text = name
        }
        
        if let url = dish?.imageUrl {
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Загружено",
                                                                     attributes: [.foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)])
            nameButton.isHidden = true
            cameraIconImageView.isHidden = true
            selectedStackView.isHidden = false
            selectedImageView.setImage(with: url)
        } else  {
            if let image = selectedImage {
                nameTextField.attributedPlaceholder = NSAttributedString(string: "Загружено",
                                                                         attributes: [.foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)])
                nameButton.isHidden = true
                cameraIconImageView.isHidden = true
                selectedStackView.isHidden = false
                selectedImageView.image = image
            } else {
                nameButton.isHidden = false
                cameraIconImageView.isHidden = false
                selectedStackView.isHidden = true
                selectedImageView.image = nil
                nameTextField.attributedPlaceholder = NSAttributedString(string: "Загрузить",
                                                                         attributes: [.foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)])
            }
        }
    }
    
    func fillSelectedImage(_ image: UIImage) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Загружено",
                                                                 attributes: [.foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)])
        nameButton.isHidden = true
        cameraIconImageView.isHidden = true
        selectedStackView.isHidden = false
        selectedImageView.image = image
    }
    
    //MARK: - Private -
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
        delegate?.showPicker()
    }
    
    @IBAction func removeSelectedImage(_ sender: Any) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Загрузить",
                                                      attributes: [.foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)])
        cameraIconImageView.isHidden = false
        nameButton.isHidden = false
        selectedStackView.isHidden = true
        selectedImageView.image = nil
        UserInfo.sharedInstance.dishFlow.dishImage = nil
        UserInfo.sharedInstance.dishFlow.imageUrl = nil
        delegate?.textChange(name: self.nameTextView.text)
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        UserInfo.sharedInstance.dishFlow.dishName = nameTextField.text
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return  textField.tag == 2 ? count <= 5 : count <= 100
    }
}

extension DishCreateFirstCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 50
    }
    
    func textViewDidChange(_ textView: UITextView) {
        titleLabel.textColor = self.nameTextView.text.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
        separatorView.backgroundColor = self.nameTextView.text.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
        delegate?.textChange(name: self.nameTextView.text)
        UIView.performWithoutAnimation {
            guard let table = self.tableView else { return }
            table.beginUpdates()
            table.endUpdates()
        }
    }
}
