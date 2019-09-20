//
//  RegistrationUserInfoViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/2/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

class RegistrationUserInfoViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var physicalActivityLabel: UILabel!
    @IBOutlet weak var loadСomplexityLabel: UILabel!
    @IBOutlet var radioButtons: [LTHRadioButton]!
    @IBOutlet var bottomSeparatorView: [UIView]!
    
    //MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
        addObserver(for: self, #selector(reloadContent), "reloadContent")
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    @objc func reloadContent() {
        setupInitialState()
    }

    //MARK: - Private -
    private func setupInitialState() {
//        loadСomplexityLabel.text = UserInfo.sharedInstance.registrationLoadСomplexity.uppercased()
        physicalActivityLabel.text = UserInfo.sharedInstance.registrationPhysicalActivity.uppercased()
    }
    
    //MARK: - Actions -
    @IBAction func radioButtonClicked(_ sender: UIButton) {
        if radioButtons.indices.contains(sender.tag) {
            guard !radioButtons[sender.tag].isSelected else { return }
            let deselect = sender.tag == 0 ? 1 : 0
            UserInfo.sharedInstance.registrationGender = sender.tag == 0 ? .man : .girl
            radioButtons[deselect].deselect(animated: true)
            radioButtons[sender.tag].select(animated: true)
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if UserInfo.sharedInstance.registrationGrowth.isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите ваш рост", vc: self)
        } else if UserInfo.sharedInstance.registrationWeight.isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите ваш вес", vc: self)
        } else if UserInfo.sharedInstance.registrationAge.isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите ваш возраст", vc: self)
        }

        guard let growth = Int(UserInfo.sharedInstance.registrationGrowth), !UserInfo.sharedInstance.registrationGrowth.hasSpecialCharacters(), growth <= 300 && growth >= 100,  growth != 0 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте введенный рост", vc: self)
        }
        guard let weight = Int(UserInfo.sharedInstance.registrationWeight), !UserInfo.sharedInstance.registrationWeight.hasSpecialCharacters(), weight <= 500, weight != 0 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте введенный вес", vc: self)
        }
        guard let age = Int(UserInfo.sharedInstance.registrationAge), !UserInfo.sharedInstance.registrationAge.hasSpecialCharacters(), age <= 200 && age >= 12, age != 0 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте ваш возраст", vc: self)
        }
        guard let _ = UserInfo.sharedInstance.registrationGender else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Выберите ваш пол", vc: self)
        }
        performSegue(withIdentifier: "sequeRegestrationScreen", sender: nil)
    }
    
    @IBAction func changeFields(_ sender: UITextField) {
        switch sender.tag {
        case 0:
            UserInfo.sharedInstance.registrationGrowth = sender.text ?? ""
        case 1:
            UserInfo.sharedInstance.registrationWeight = sender.text ?? ""
        case 2:
            UserInfo.sharedInstance.registrationAge = sender.text ?? ""
        default:
            break
        }
    }
}

extension RegistrationUserInfoViewController: UITextFieldDelegate {
    
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

extension RegistrationUserInfoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            guard scrollView.contentOffset.y > 0 else {
                return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
        }
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            scrollView.isScrollEnabled = true
            var contentInset = scrollView.contentInset
            contentInset.bottom = keyboardHeight
            scrollView.contentInset = contentInset
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.isScrollEnabled = false
    }
}
