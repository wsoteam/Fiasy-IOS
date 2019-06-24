//
//  AddRecipeTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown

class AddRecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
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
    private var dropDown = DropDown()
    private var delegate: AddRecipeDelegate?
    
    // MARK: - Interface -
    func fillCell(indexCell: IndexPath, delegate: AddRecipeDelegate) {
        self.delegate = delegate
        
        cameraIconImageView.isHidden = indexCell.row != 1
        bottomContainerView.isHidden = indexCell.row != 3
        
        switch indexCell.row {
            case 0:
                titleLabel.text = "Название рецепта"
                nameTextField.attributedPlaceholder = NSAttributedString(string: "Завтрак",
                                    attributes: [.foregroundColor: UIColor.black])
            case 1:
                titleLabel.text = "Изображение блюда"
                nameTextField.attributedPlaceholder = NSAttributedString(string: "Загрузить",
                                                attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
            case 2:
                titleLabel.text = "Время приготовления (мин)"
                nameTextField.attributedPlaceholder = NSAttributedString(string: "0",
                                                attributes: [.foregroundColor: UIColor.black])
            case 3:
                titleLabel.text = "Сложность"
                nameTextField.attributedPlaceholder = NSAttributedString(string: "Выбрать сложность",
                                                attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString(string: "Созданные вами и введенные в базу рецепты или продукты могут быть\nдоступны для других пользователей. Пожалуйста, постарайтесь заполнить\nприведенную выше форму максимально точно и полно.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        descriptionLabel.attributedText = attributedString
        nameButton.isHidden = indexCell.row == 0 || indexCell.row == 2
        nameButton.tag = indexCell.row
        nameTextField.isEnabled = indexCell.row == 0 || indexCell.row == 2
        
        fillDropDown()
    }
    
    func fillSelectedImage(_ image: UIImage) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Загруженно",
                                                      attributes: [.foregroundColor: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)])
        nameButton.isHidden = true
        cameraIconImageView.isHidden = true
        selectedStackView.isHidden = false
        selectedImageView.image = image
    }
    
    //MARK: - Private -
    private func fillDropDown() {
        DropDown.appearance().textFont = UIFont.fontRobotoMedium(size: 15)
        dropDown.dataSource.append("Легкая")
        dropDown.dataSource.append("Средняя")
        dropDown.dataSource.append("Сложная")
        
        dropDown.anchorView = separatorView
        dropDown.textColor = #colorLiteral(red: 0.7136465907, green: 0.7137710452, blue: 0.7136388421, alpha: 1)
        dropDown.selectedTextColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height ?? 0) + 5)

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else { return }
            strongSelf.nameTextField.text = item
            strongSelf.nameTextField.textColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
        }
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
    }
}
