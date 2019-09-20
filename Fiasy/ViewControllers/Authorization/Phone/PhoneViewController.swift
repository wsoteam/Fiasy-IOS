//
//  PhoneViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/9/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

class PhoneViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet var bottomSeparatorView: [UIView]!

    // MARK: - Life cycle -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showAnimate()
        phoneTextField.becomeFirstResponder()
    }
    
    // MARK: - Private -
    private func showAnimate() {
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0.0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.alpha = 1.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    private func removeAnimate() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.containerView.alpha = 0.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {[weak self] _ in
                self?.dismiss(animated: true)
        })
    }
    
    // MARK: - Action -
    @IBAction func closeClicked(_ sender: UIButton) {
        removeAnimate()
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        view.endEditing(true)
        guard let phone = self.phoneTextField.text, let code = codeTextField.text, !phone.isEmpty else { return }
        if let send = sendButton.titleLabel?.text, send.lowercased() == "ОТПРАВИТЬ".lowercased()  {
            PhoneAuthProvider.provider().verifyPhoneNumber(phone) { [weak self] (verificationID, error) in
                guard let strongSelf = self else { return }
                if let _ = error {
                    let message = "Введен неправильный номер. Проверьте номер и повторите попытку."
                    return AlertComponent.sharedInctance.showAlertMessage(title: "Неправильный номер",
                                                                 message: message,
                                                                      vc: strongSelf)
                } else {
                    strongSelf.sendButton.isEnabled = false
                    strongSelf.descriptionLabel.text = "Вам выслан код. Введите его"
                    strongSelf.sendButton.setTitle("ВОЙТИ", for: .normal)
                    strongSelf.phoneTextField.isEnabled = false
                    strongSelf.codeTextField.isEnabled = true
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    UserDefaults.standard.synchronize()
                }
            }
        } else {
            if let verificationID = UserDefaults.standard.value(forKey: "authVerificationID") {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as? String ?? "", verificationCode: code)
                Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                    guard let strongSelf = self else { return }
                    if let _ = error {
                        let message = "Введен неправильный код. Пожалуйста, повторите попытку."
                        return AlertComponent.sharedInctance.showAlertMessage(title: "Неверный код",
                                                                     message: message,
                                                                          vc: strongSelf)
                    } else {
                        FirebaseDBManager.checkFilledProfile { (state) in }
                        strongSelf.performSegue(withIdentifier: "segueToMenu", sender: nil)
                    }
                })
            }
        }
    }
}

extension PhoneViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if textField.tag == 1 {
            textField.text = newString.isEmpty ? "" : newString
        } else {
            textField.text = newString.isEmpty ? "" : newString.add(prefix: "+")
        }
        
        if let first = phoneTextField.text, first.isEmpty {
            sendButton.isEnabled = false
        } else if let second = codeTextField.text, second.isEmpty && codeTextField.isEnabled {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if bottomSeparatorView.indices.contains(textField.tag) {
            bottomSeparatorView[textField.tag].backgroundColor = #colorLiteral(red: 0.5685634613, green: 0.568664372, blue: 0.5685571432, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if bottomSeparatorView.indices.contains(textField.tag) {
            bottomSeparatorView[textField.tag].backgroundColor = #colorLiteral(red: 0.8783355355, green: 0.8784865737, blue: 0.8783260584, alpha: 1)
        }
    }
}
