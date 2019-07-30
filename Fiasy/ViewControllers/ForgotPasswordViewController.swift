//
//  ForgotPasswordViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/1/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    //MARK: - Outlet -
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var secondSpace: NSLayoutConstraint!
    @IBOutlet weak var sendDescriptionLabel: UILabel!
    @IBOutlet weak var sendButton: LoadingButton!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spaceViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    //MARK: - Actions -
    @IBAction func closeClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Закрыть фому?", message: "Закрывая форму, вы не сможете\nвосстановить пароль", preferredStyle: .alert)
    
        let close = UIAlertAction(title: "Закрыть", style: .default) { (alert) in
            self.dismiss(animated: true)
        }
        close.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        alert.addAction(close)

        let continueAction = UIAlertAction(title: "Продолжить", style: .cancel, handler: nil)
        continueAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        alert.addAction(continueAction)
        alert.setValue(NSAttributedString(string: alert.title ?? "", attributes: [.font : UIFont.sfProTextSemibold(size: 17), .foregroundColor : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [.font : UIFont.sfProTextRegular(size: 13), .foregroundColor : #colorLiteral(red: 0.3803474307, green: 0.3804178834, blue: 0.38034302, alpha: 1)]), forKey: "attributedMessage")

        self.present(alert, animated: true)
    }

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        guard let text = emailTextField.text, !text.isEmpty else { return }
        guard text.isValidEmail() else {
            errorLabel.text = "Неверный формат почты"
            separatorView.backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            errorLabel.alpha = 1
            return
        }
        sendButton.showLoading()
        Auth.auth().sendPasswordReset(withEmail: text, completion: { (error) in
            self.sendButton.hideLoading()
            if let _ = error {
                self.separatorView.backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
                self.errorLabel.text = "Данного пользователя не существует"
                self.errorLabel.alpha = 1
            } else {
                self.sendDescriptionLabel.text = "Проверьте почту"
                self.sendButton.setTitle("  ОТПРАВЛЕННО", for: .normal)
                self.sendButton.setImage(#imageLiteral(resourceName: "Shape (2)"), for: .normal)
                self.delayWithSeconds(2) {
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        if isIphone5 {
            titleLabel.font = titleLabel.font.withSize(25)
            emailTitleLabel.font = emailTitleLabel.font.withSize(12)
            sendButtonHeightConstraint.constant = 44
            sendButton.IBcornerRadius = 22
            sendButton.titleLabel?.font = sendButton.titleLabel?.font.withSize(14)
            sendDescriptionLabel.font = sendDescriptionLabel.font.withSize(13)
        }
    }
    
    private func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        sendButton.isEnabled = (updatedString?.count ?? 0) > 0
        sendButton.backgroundColor = (updatedString?.count ?? 0) > 0 ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1) : #colorLiteral(red: 0.7803063989, green: 0.7804415822, blue: 0.780297935, alpha: 1)
        separatorView.backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
        errorLabel.alpha = 0
        return true
    }
}

extension ForgotPasswordViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            secondSpace.constant = 100
            spaceViewConstraint.constant = isIphone5 ? 30 : 50
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        secondSpace.constant = 0
        spaceViewConstraint.constant = 100
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
