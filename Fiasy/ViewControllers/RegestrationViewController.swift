import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import BEMCheckBox
import Amplitude_iOS

class RegestrationViewController: BaseViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        Amplitude.instance().logEvent("start_registration")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
    }
  
    //MARK: - Action -
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        guard checkBox.on else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Для регистрации нужно согласия с условиями политики конфиденциальности", vc: self)
        }
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Отсутствует подключение к интернету", vc: self)
        }
        if let email = emailTextField.text, let password = passwordTextField.text, email.isEmpty || password.isEmpty {
            let text = (emailTextField.text ?? "").isEmpty ? "Введите email" : "Введите пароль"
            return AlertComponent.sharedInctance.showAlertMessage(message: text, vc: self)
        }
        guard (emailTextField.text ?? "").isValidEmail() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте введенный email!", vc: self)
        }
        guard (passwordTextField.text ?? "").count >= 6 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Пароль слишком простой", vc: self)
        }
        
        Auth.auth().createUser(withEmail: (emailTextField.text ?? ""), password: (passwordTextField.text ?? "")) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            guard let _ = error else {
                var first = "default"
                var last = "default"
                let fullNameArr = user?.displayName?.characters.split{$0 == " "}.map(String.init)
                if let array = fullNameArr, array.indices.contains(0) {
                    first = array[0]
                }
                if let array = fullNameArr, array.indices.contains(1) {
                    last = array[1]
                }
                
                FirebaseDBManager.saveUserInDataBase(user?.photoURL?.absoluteString ?? "", firstName: first, lastName: last)
                FirebaseDBManager.checkFilledProfile()
                return strongSelf.performSegue(withIdentifier: "segueToMenu", sender: nil)
            }
            AlertComponent.sharedInctance.showAlertMessage(message: "Такой пользователь уже существует",
                                                          vc: strongSelf)
        }
    }
    
    @IBAction func googleClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Отсутствует подключение к интернету", vc: self)
        }
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func phoneClicked(_ sender: Any) {
        performSegue(withIdentifier: "sequePhoneScreen", sender: nil)
    }
    
    @IBAction func facebookClicked(_ sender: Any) {
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Отсутствует подключение к интернету", vc: self)
        }
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard result?.isCancelled != true else { return }
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString), completion: { (user, error) in
                if let error = error {
                    if let strongSelf = self {
                        return AlertComponent.sharedInctance.showAlertMessage(title: "Login Error",
                                    message: error.localizedDescription, vc: strongSelf)
                    }
                }
                
                var first = ""
                var last = ""
                let fullNameArr = user?.displayName?.characters.split{$0 == " "}.map(String.init)
                if let array = fullNameArr, array.indices.contains(0) {
                    first = array[0]
                }
                if let array = fullNameArr, array.indices.contains(1) {
                    last = array[1]
                }
                
                FirebaseDBManager.saveUserInDataBase(user?.photoURL?.absoluteString ?? "", firstName: first, lastName: last)
                FirebaseDBManager.checkFilledProfile()
                self?.performSegue(withIdentifier: "segueToMenu", sender: nil)
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return newString.count <= 320
    }

    //MARK: - Private -
    private func setupInitialState() {
        checkBox.boxType = .square
        checkBox.onFillColor = .clear
        checkBox.onCheckColor = #colorLiteral(red: 0.2745942175, green: 0.2475363314, blue: 0.2095298767, alpha: 1)
        checkBox.onTintColor = #colorLiteral(red: 0.2745942175, green: 0.2475363314, blue: 0.2095298767, alpha: 1)
    }
}

extension RegestrationViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            guard error.localizedDescription != "The user canceled the sign-in flow." else {
                return
            }
        }
        let first = user.profile.givenName ?? ""
        let last = user.profile.familyName ?? ""
        if let error = error {
            return AlertComponent.sharedInctance.showAlertMessage(title: "Ошибка",
                                            message: error.localizedDescription, vc: self)
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential, completion: { [unowned self] (user, error) in
                if let error = error {
                    return AlertComponent.sharedInctance.showAlertMessage(title: "Ошибка",
                                         message: error.localizedDescription, vc: self)
                } else {
                    FirebaseDBManager.saveUserInDataBase(user?.photoURL?.absoluteString ?? "", firstName: first, lastName: last)
                    FirebaseDBManager.checkFilledProfile()
                    self.performSegue(withIdentifier: "segueToMenu", sender: nil)
                }
            })
        }
    }
}
