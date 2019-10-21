import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import Amplitude_iOS
import FirebaseStorage

class RegestrationViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var orSignInByLabel: UILabel!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var allTextFields: [UITextField]!
    @IBOutlet var passwordButtons: [UIButton]!
    @IBOutlet var allErrorLabels: [UILabel]!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var allSeparatorViews: [UIView]!

    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeDesign()
        setupInitialState()
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
        Amplitude.instance()?.logEvent("registration_next", withEventProperties: ["push_button" : "email"]) // +
        
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .NO_INTERNET_CONNECTION), vc: self)
        }
        guard (allTextFields[0].text ?? "").isValidEmail() else {
            allErrorLabels[0].text = LS(key: .WRONG_MAIL_ERROR)
            allSeparatorViews[0].backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            allErrorLabels[0].isHidden = false
            animateView()
            return
        }
        guard (allTextFields[1].text ?? "").count >= 6 else {
            allErrorLabels[1].text = LS(key: .SIMPLE_PASSWORD_ERROR)
            allSeparatorViews[1].backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            allErrorLabels[1].isHidden = false
            animateView()
            return
        }
        
        guard (allTextFields[1].text ?? "") == (allTextFields[2].text ?? "") else {
            allErrorLabels[1].text = LS(key: .PASSWORD_DONT_MATCH)
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
                Amplitude.instance()?.logEvent("registration_success", withEventProperties: ["type" : "email"]) // +
                
                let identify = AMPIdentify()
                identify.set("registration", value: "email" as NSObject)
                Amplitude.instance()?.identify(identify)
                
                if let uid = Auth.auth().currentUser?.uid {
                    let ref = Database.database().reference()
                    let child = ref.child("USER_LIST").child(uid).child("profile")
                    child.child("email").setValue(email)
                }
                
                return strongSelf.performSegue(withIdentifier: "sequeQuizScreen", sender: nil)
            }
            
            AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .USER_ALREADY_EXISTS),
                                                          vc: strongSelf)
        }
    }
    
    @IBAction func googleClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("registration_next", withEventProperties: ["push_button" : "google"]) // +
        
        GIDSignIn.sharedInstance().signOut()
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .NO_INTERNET_CONNECTION), vc: self)
        }
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func privacyClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("registration_next", withEventProperties: ["push_button" : "privacy"]) // +
    }
    
    @IBAction func facebookClicked(_ sender: Any) {
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .NO_INTERNET_CONNECTION), vc: self)
        }
        Amplitude.instance()?.logEvent("registration_next", withEventProperties: ["push_button" : "fb"]) // +
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
            var fetchedEmail: String = ""
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"]).start(completionHandler: { (connection, result, error) in
                if error == nil {
                    if let dictionary = result as? [String : Any], let fetchEmail = dictionary["email"] as? String {
                        fetchedEmail = fetchEmail
                    }
                } else {
                    print("Error Getting Info \(error)");
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
                UserInfo.sharedInstance.registrationFlow.email = fetchedEmail
                Amplitude.instance()?.logEvent("registration_success", withEventProperties: ["type" : "fb"]) // +

                let identify = AMPIdentify()
                identify.set("registration", value: "facebook" as NSObject)
                Amplitude.instance()?.identify(identify)
                
                strongSelf.performSegue(withIdentifier: "sequeQuizScreen", sender: nil)
            })
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
    
    private func localizeDesign() {
        screenNameLabel.text = LS(key: .SIGN_UP_TITLE)
        for (index, item) in titleLabels.enumerated() {
            switch index {
            case 0:
                item.text = LS(key: .WRITE_EMAIL)
            case 1:
                item.text = LS(key: .WRITE_PASSWORD)
            default:
                item.text = LS(key: .REPEAT_PASSWORD)
            }
        }
        signUpButton.setTitle(LS(key: .SIGN_IN_TITLE), for: .normal)
        agreeLabel.text = LS(key: .AGREE_WITH_CONDITIONS)
        privacyButton.setTitle(LS(key: .PRIVACY_POLICY), for: .normal)
        orSignInByLabel.text = LS(key: .OR_SIGN_IN_BY)
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
            return AlertComponent.sharedInctance.showAlertMessage(title: LS(key: .ERROR),
                                            message: error.localizedDescription, vc: self)
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    return AlertComponent.sharedInctance.showAlertMessage(title: LS(key: .ERROR),
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
                    Amplitude.instance()?.logEvent("registration_success", withEventProperties: ["type" : "google"]) // +

                    let identify = AMPIdentify()
                    identify.set("registration", value: "google" as NSObject)
                    Amplitude.instance()?.identify(identify)
                    
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
