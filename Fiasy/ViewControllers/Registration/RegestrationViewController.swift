import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import Amplitude_iOS
import Intercom

class RegestrationViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet var allSeparatorViews: [UIView]!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var allTextFields: [UITextField]!
    @IBOutlet var passwordButtons: [UIButton]!
    @IBOutlet var allErrorLabels: [UILabel]!
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        Amplitude.instance().logEvent("start_registration")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
  
    //MARK: - Action -
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func fillPasswordField(_ sender: UITextField) {
        if (sender.tag - 1) == 0 {
            guard let text = sender.text, !text.isEmpty else {
                return passwordButtons[0].isHidden = true
            }
            passwordButtons[0].isHidden = false
        } else {
            guard let text = sender.text, !text.isEmpty else {
                return passwordButtons[1].isHidden = true
            }
            passwordButtons[1].isHidden = false
        }
    }
    
    @IBAction func showPasswordClicked(_ sender: UIButton) {
        let textField: UITextField = allTextFields[sender.tag]
        if sender.isSelected == true {
            textField.isSecureTextEntry = true
            sender.isSelected = false
        } else {
            textField.isSecureTextEntry = false
            sender.isSelected = true
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Отсутствует подключение к интернету", vc: self)
        }
        guard (allTextFields[0].text ?? "").isValidEmail() else {
            allErrorLabels[0].text = "Неверный формат почты"
            allSeparatorViews[0].backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            allErrorLabels[0].isHidden = false
            animateView()
            return
        }
        guard (allTextFields[1].text ?? "").count >= 6 else {
            allErrorLabels[1].text = "Пароль слишком простой"
            allSeparatorViews[1].backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            allErrorLabels[1].isHidden = false
            animateView()
            return
        }
        
        guard (allTextFields[1].text ?? "") == (allTextFields[2].text ?? "") else {
            allErrorLabels[1].text = "Не совпадают пароли"
            allSeparatorViews[1].backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            allSeparatorViews[2].backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            allErrorLabels[1].isHidden = false
            animateView()
            return
        }
        let email = (allTextFields[0].text ?? "")

        Auth.auth().createUser(withEmail: email, password: (allTextFields[1].text ?? "")) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            guard let _ = error else {
                let fullNameArr = user?.displayName?.characters.split{$0 == " "}.map(String.init)
                if let array = fullNameArr, array.indices.contains(0) {
                    UserInfo.sharedInstance.registrationFlow.firstName = array[0]
                }
                UserInfo.sharedInstance.registrationFlow.email = email
                if let array = fullNameArr, array.indices.contains(1) {
                    UserInfo.sharedInstance.registrationFlow.lastName = array[1]
                }
                if let url = user?.photoURL?.absoluteString {
                    UserInfo.sharedInstance.registrationFlow.photoUrl = url
                }
                Intercom.registerUser(withEmail: email)
                Intercom.logEvent(withName: "registration_success", metaData: ["type" : "email"])
                Amplitude.instance()?.logEvent("registration_success", withEventProperties: ["type" : "email"])
                
                if let uid = Auth.auth().currentUser?.uid {
                    Intercom.registerUser(withUserId: uid)
                }
                return strongSelf.performSegue(withIdentifier: "sequeQuizScreen", sender: nil)
            }
            
            Intercom.logEvent(withName: "registration_error")
            Amplitude.instance()?.logEvent("registration_error")
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

    @IBAction func facebookClicked(_ sender: Any) {
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Отсутствует подключение к интернету", vc: self)
        }
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard result?.isCancelled != true else { return }
            guard let strongSelf = self else { return }
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
                let fullNameArr = user?.displayName?.characters.split{$0 == " "}.map(String.init)
                if let array = fullNameArr, array.indices.contains(0) {
                    UserInfo.sharedInstance.registrationFlow.firstName = array[0]
                }
                if let array = fullNameArr, array.indices.contains(1) {
                    UserInfo.sharedInstance.registrationFlow.lastName = array[1]
                }
                if let url = user?.photoURL?.absoluteString {
                    UserInfo.sharedInstance.registrationFlow.photoUrl = url
                }
                UserInfo.sharedInstance.registrationFlow.email = user?.email ?? ""
                Intercom.registerUser(withEmail: user?.email ?? "")
                Intercom.logEvent(withName: "registration_success", metaData: ["type" : "fb"])
                Amplitude.instance()?.logEvent("registration_success", withEventProperties: ["type" : "fb"])
                
                strongSelf.performSegue(withIdentifier: "sequeQuizScreen", sender: nil)
            })
        }
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        //
    }
    
    private func animateView() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension RegestrationViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dismissing Google SignIn")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            guard error.localizedDescription != "The user canceled the sign-in flow." else {
                return
            }
        }
        let first = user.profile.givenName
        let last = user.profile.familyName
        let email = user.profile.email
        if let error = error {
            return AlertComponent.sharedInctance.showAlertMessage(title: "Ошибка",
                                            message: error.localizedDescription, vc: self)
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    return AlertComponent.sharedInctance.showAlertMessage(title: "Ошибка",
                                         message: error.localizedDescription, vc: strongSelf)
                } else {
                    if let firsts = first {
                        UserInfo.sharedInstance.registrationFlow.firstName = firsts
                    }
                    if let lasts = last {
                        UserInfo.sharedInstance.registrationFlow.lastName = lasts
                    }
                    if let url = user?.photoURL?.absoluteString {
                        UserInfo.sharedInstance.registrationFlow.photoUrl = url
                    }
                    UserInfo.sharedInstance.registrationFlow.email = email ?? ""
                    Intercom.registerUser(withEmail: email ?? "")
                    Intercom.logEvent(withName: "registration_success", metaData: ["type" : "google"])
                    Amplitude.instance()?.logEvent("registration_success", withEventProperties: ["type" : "google"])
                    strongSelf.performSegue(withIdentifier: "sequeQuizScreen", sender: nil)
                }
            })
        }
    }
}

extension RegestrationViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        var state: Bool = false
        switch textField.tag {
        case 0:
            allErrorLabels[0].isHidden = true
            allSeparatorViews[0].backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
            if (updatedString ?? "").count > 0 && (allTextFields[1].text ?? "").count > 0 && (allTextFields[2].text ?? "").count > 0 {
                state = true
            } else {
                state = false
            }
        case 1:
            allErrorLabels[1].isHidden = true
            allSeparatorViews[1].backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
            if (updatedString ?? "").count > 0 && (allTextFields[0].text ?? "").count > 0 && (allTextFields[2].text ?? "").count > 0 {
                state = true
            } else {
                state = false
            }
        case 2:
            allErrorLabels[2].isHidden = true
            allSeparatorViews[2].backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
            if (updatedString ?? "").count > 0 && (allTextFields[0].text ?? "").count > 0 && (allTextFields[1].text ?? "").count > 0 {
                state = true
            } else {
                state = false
            }
        default:
            break
        }
        animateView()
        signUpButton.isEnabled = state ? true : false
        signUpButton.backgroundColor = state ? #colorLiteral(red: 1, green: 0.6055343747, blue: 0.1803497076, alpha: 1) : #colorLiteral(red: 0.7803063989, green: 0.7804415822, blue: 0.780297935, alpha: 1)
        return true
    }
}
