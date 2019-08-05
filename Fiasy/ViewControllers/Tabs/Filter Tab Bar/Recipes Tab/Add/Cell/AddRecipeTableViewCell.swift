//
//  AddRecipeTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown

class AddRecipeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var fixedView: UIView!
    @IBOutlet weak var resizeView: UIView!
    @IBOutlet weak var selectedStackView: UIStackView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomContainerView: UIView!
    
    //MARK: - Properties -
    var dropDown = DropDown()
    private var tableView: UITableView?
    private var delegate: AddRecipeDelegate?
    private var defaultUrl = "https://firebasestorage.googleapis.com/v0/b/diet-for-test.appspot.com/o/default_recipe.png?alt=media&token=1fcf855f-fa9d-4831-9ff2-af204a612707"
    
    // MARK: - Interface -
    func fillCell(_ tableView: UITableView, indexCell: IndexPath, delegate: AddRecipeDelegate, _ selectedImage: UIImage?, _ selectedRecipe: Listrecipe?) {
        self.delegate = delegate
        self.tableView = tableView
        
        resizeView.isHidden = true
        fixedView.isHidden = false
        cameraIconImageView.isHidden = indexCell.row != 1
        nameButton.isHidden = indexCell.row == 0 || indexCell.row == 2
        bottomContainerView.isHidden = true
        nameTextField.tag = indexCell.row
        switch indexCell.row {
            case 0:
//                fillNecessarilyField(label: titleLabel, text: "Название рецепта")
//                nameTextField.attributedPlaceholder = NSAttributedString(string: "",
//                                    attributes: [.foregroundColor: UIColor.black])
//            nameTextField.keyboardType = .default
                
            if let selected = selectedRecipe {
                  nameTextView.text = selected.name
            }
            
                resizeView.isHidden = false
                fixedView.isHidden = true
            case 1:
                titleLabel.text = "Изображение блюда"
                
                if let url = selectedRecipe?.url, url != defaultUrl {
                    nameTextField.attributedPlaceholder = NSAttributedString(string: "Загружено",
                                                                             attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
                    nameButton.isHidden = true
                    cameraIconImageView.isHidden = true
                    selectedStackView.isHidden = false
                    selectedImageView.setImage(with: url)
                    UserInfo.sharedInstance.recipeFlow.recipeImage = selectedImageView.image
                } else  {
                    if let image = selectedImage {
                        nameTextField.attributedPlaceholder = NSAttributedString(string: "Загружено",
                                                                                 attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
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
                                                                                 attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
                    }
                }
            case 2:
                fillNecessarilyField(label: titleLabel, text: "Время приготовления (мин)")
                nameTextField.attributedPlaceholder = NSAttributedString(string: "",
                                                attributes: [.foregroundColor: UIColor.black])
                nameTextField.keyboardType = .numberPad
                if let selected = selectedRecipe {
                    nameTextField.text = "\(selected.time ?? 0)"
                }
            case 3:
                fillNecessarilyField(label: titleLabel, text: "Сложность")
                nameTextField.attributedPlaceholder = NSAttributedString(string: "Выбрать сложность",
                                                attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
                if let selected = selectedRecipe {
                    nameTextField.text = "\(selected.complexity ?? "")"
                    nameTextField.textColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
                }
            
                if let _ = selectedRecipe {
                    bottomContainerView.isHidden = true
                } else {
                    bottomContainerView.isHidden = false
                }
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString(string: "Созданные вами и введенные в базу рецепты или продукты могут быть\nдоступны для других пользователей. Пожалуйста, постарайтесь заполнить\nприведенную выше форму максимально точно и полно.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        descriptionLabel.attributedText = attributedString
        
        nameButton.tag = indexCell.row
        nameTextField.isEnabled = indexCell.row == 0 || indexCell.row == 2
        
        fillDropDown(selectedRecipe)
    }
    
    func fillSelectedImage(_ image: UIImage) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Загружено",
                                                      attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
        nameButton.isHidden = true
        cameraIconImageView.isHidden = true
        selectedStackView.isHidden = false
        selectedImageView.image = image
    }
    
    //MARK: - Private -
    private func fillDropDown(_ selectedRecipe: Listrecipe?) {
        DropDown.appearance().textFont = UIFont.fontRobotoMedium(size: 15)
        dropDown.dataSource.append("Легкая")
        dropDown.dataSource.append("Средняя")
        dropDown.dataSource.append("Сложная")
        
        dropDown.anchorView = separatorView
        dropDown.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dropDown.selectedTextColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height ?? 0) + 5)

        if let selected = selectedRecipe {
            for (index,item) in dropDown.dataSource.enumerated() where item == selected.complexity {
                dropDown.selectRow(index)
            }
        }
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else { return }
            strongSelf.nameTextField.text = item
            strongSelf.nameTextField.textColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
            strongSelf.delegate?.textChange(tag: 3, text: item)
        }
    }
    
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
        if sender.tag == 1 {
            delegate?.showPicker()
        } else {
            dropDown.show()
        }
    }
    
    @IBAction func removeSelectedImage(_ sender: Any) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Загрузить",
                                                      attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
        cameraIconImageView.isHidden = false
        nameButton.isHidden = false
        selectedStackView.isHidden = true
        selectedImageView.image = nil
        UserInfo.sharedInstance.recipeFlow.recipeImage = nil
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        delegate?.textChange(tag: sender.tag, text: nameTextField.text)
    }
    
    @IBAction func switchChangeClicked(_ sender: UISwitch) {
        delegate?.switchChangeValue(state: sender.isOn)
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

extension AddRecipeTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        delegate?.textChange(tag: 0, text: newText)
        return newText.count <= 100
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.performWithoutAnimation {
            guard let table = self.tableView else { return }
            table.beginUpdates()
            table.endUpdates()
        }
    }
}

