//
//  ForgotPasswordViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/1/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: BaseViewController {

    //MARK: - Outlet -
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions -
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        guard let text = emailTextField.text, !text.isEmpty else { return }
        guard text.isValidEmail() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте введенный email!", vc: self)
        }
        Auth.auth().sendPasswordReset(withEmail: text, completion: { (error) in
            if let _ = error {
                self.showError(title: "Ошибка", message: "Данного пользователя не существует", complete: {})
            } else {
                self.showError(title: "Внимание", message: "Пароль отправлен на ваш email адресс", complete: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        })
    }
}
