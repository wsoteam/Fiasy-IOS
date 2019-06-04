//
//  EditProfileViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

class EditProfileViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var physicalActivityLabel: UILabel!
    @IBOutlet var radioButtons: [LTHRadioButton]!
    @IBOutlet var bottomSeparatorView: [UIView]!
    
    //MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillAllFields()
        setupInitialState()
        Amplitude.instance().logEvent("edit_profile")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialState()
        hideKeyboardWhenTappedAround()
        addObserver(for: self, #selector(reloadActivity), "reloadContent")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    @objc func reloadActivity() {
       physicalActivityLabel.text = UserInfo.sharedInstance.physicalActivity.uppercased()
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        for button in radioButtons {
            button.deselect()
        }
        
        if UserInfo.sharedInstance.currentUser?.female == true {
            radioButtons[1].select()
        } else {
            radioButtons[0].select()
        }
        
        physicalActivityLabel.text = UserInfo.sharedInstance.currentUser?.exerciseStress?.uppercased()
        if let first = UserInfo.sharedInstance.currentUser?.firstName, let last = UserInfo.sharedInstance.currentUser?.lastName, (!first.isEmpty && first.lowercased() != "default") && (!last.isEmpty && last.lowercased() != "default") {
            textFields[0].text = first
            textFields[1].text = last
        } else {
            textFields[0].text = ""
            textFields[1].text = ""
        }
        
        if let height = UserInfo.sharedInstance.currentUser?.height {
            textFields[2].text = height == 0 ? "" : "\(height)"
        }
        if let weight = UserInfo.sharedInstance.currentUser?.weight {
            textFields[3].text = weight == 0 ? "" : "\(weight)"
        }
        if let age = UserInfo.sharedInstance.currentUser?.age {
            textFields[4].text = age == 0 ? "" : "\(age)"
        }
    }
    
    private func fillAllFields() {
        if radioButtons.indices.contains(UserInfo.sharedInstance.userGender.rawValue) {
            radioButtons[UserInfo.sharedInstance.userGender.rawValue].select(animated: false)
        }
    }
    
    //MARK: - Actions -
    @IBAction func radioButtonClicked(_ sender: UIButton) {
        if radioButtons.indices.contains(sender.tag) {
            guard !radioButtons[sender.tag].isSelected else { return }
            let deselect = sender.tag == 0 ? 1 : 0
            radioButtons[deselect].deselect(animated: true)
            radioButtons[sender.tag].select(animated: true)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        if (textFields[0].text ?? "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите вашe имя", vc: self)
        } else if (textFields[1].text ?? "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите вашу фамилию", vc: self)
        }
        
        if (textFields[2].text ?? "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите ваш рост", vc: self)
        } else if (textFields[3].text ?? "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите ваш вес", vc: self)
        } else if (textFields[4].text ?? "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите ваш возраст", vc: self)
        }
        
        guard !(textFields[0].text ?? "").hasSpecialCharacters() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте ваше имя", vc: self)
        }
        
        guard !(textFields[1].text ?? "").hasSpecialCharacters() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте вашу фамилию", vc: self)
        }
        
        guard let growth = Int((textFields[2].text ?? "")), !(textFields[2].text ?? "").hasSpecialCharacters(), growth <= 300 && growth >= 100, growth != 0 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте введенный рост", vc: self)
        }
        guard let weight = Int((textFields[3].text ?? "")), !(textFields[3].text ?? "").hasSpecialCharacters(), weight <= 500, weight != 0 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте введенный вес", vc: self)
        }
        guard let age = Int((textFields[4].text ?? "")), !(textFields[4].text ?? "").hasSpecialCharacters(), age <= 200 && age >= 12, age != 0 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте ваш возраст", vc: self)
        }
        
        UserInfo.sharedInstance.fillAllFields(fields: textFields, female: radioButtons[1].isSelected)
        navigationController?.popViewController(animated: true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        return !((updatedString?.count ?? 0) > 30)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if bottomSeparatorView.indices.contains(textField.tag) {
            bottomSeparatorView[textField.tag].backgroundColor = #colorLiteral(red: 1, green: 0.7573882937, blue: 0.02864617109, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if bottomSeparatorView.indices.contains(textField.tag) {
            bottomSeparatorView[textField.tag].backgroundColor = #colorLiteral(red: 0.6352232695, green: 0.6353349686, blue: 0.6352162957, alpha: 1)
        }
    }
}
