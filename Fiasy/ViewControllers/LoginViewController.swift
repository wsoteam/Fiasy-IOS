import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var passwordSeparatorView: UIView!
    @IBOutlet weak var emailSeparatorView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var forgotLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet var fieldsTitleLabel: [UILabel]!
    @IBOutlet weak var signInButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var signInStackView: UIStackView!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private let ref: DatabaseReference = Database.database().reference()
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
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }

    //MARK: - Actions -
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emailLogin(_ sender: Any) {
        guard let email = loginField.text, email.isValidEmail() else {
            emailErrorLabel.text = "Неверный формат почты"
            emailSeparatorView.backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            emailErrorLabel.alpha = 1
            return
        }
        Auth.auth().signIn(withEmail: email, password: passwordField.text ?? "") { [weak self] user, error in
            guard let strongSelf = self else { return }
            if let _ = error {
                strongSelf.passwordErrorLabel.text = "Неверные данные"
                strongSelf.passwordErrorLabel.alpha = 1
                strongSelf.emailSeparatorView.backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
                strongSelf.passwordSeparatorView.backgroundColor = #colorLiteral(red: 0.9153415561, green: 0.3059891462, blue: 0.3479152918, alpha: 1)
            } else {
                if Auth.auth().currentUser != nil {
                    FirebaseDBManager.checkFilledProfile()
                    strongSelf.performSegue(withIdentifier: "segueToMenu", sender: nil)
                }
            }
        }
    }

    @IBAction func facebookLogin(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            guard result?.isCancelled != true else { return }
            if let error = error {
                return print("Failed to login: \(error.localizedDescription)")
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    return AlertComponent.sharedInctance.showAlertMessage(title: "Login Error",
                                                message: error.localizedDescription, vc: self)
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
                self.performSegue(withIdentifier: "sequeQuizScreen", sender: nil)
            })
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        guard isConnectedToNetwork() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Отсутствует подключение к интернету", vc: self)
        }
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func fillPassword(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            return passwordEyeButton.isHidden = true
        }
        passwordEyeButton.isHidden = false
    }
    
    @IBAction func showPasswordClicked(_ sender: UIButton) {
        if sender.isSelected == true {
            passwordField.isSecureTextEntry = true
            sender.isSelected = false
        } else {
            passwordField.isSecureTextEntry = false
            sender.isSelected = true
        }
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        if isIphone5 {
            centerConstraint.constant = 55
            screenTitleLabel.font = screenTitleLabel.font.withSize(25)
            signInButtonHeightConstraint.constant = 44
            signInButton.IBcornerRadius = 22
            signInButton.titleLabel?.font = signInButton.titleLabel?.font.withSize(14)
            resetPasswordHeight.constant = 30
            orLabel.font = orLabel.font.withSize(11)
            forgotLabel.font = forgotLabel.font.withSize(13)
            resetPasswordButton.titleLabel?.font = resetPasswordButton.titleLabel?.font.withSize(13)
            for item in fieldsTitleLabel {
                item.font = item.font.withSize(12)
            }
        }
    }
}

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dismissing Google SignIn")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            guard error.localizedDescription != "The user canceled the sign-in flow." else {
                return
            }
            return AlertComponent.sharedInctance.showAlertMessage(title: "Login Error",
                                                         message: error.localizedDescription, vc: self)
        } else {
            let first = user.profile.givenName
            let last = user.profile.familyName
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    return AlertComponent.sharedInctance.showAlertMessage(title: "Login Error",
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
                    strongSelf.performSegue(withIdentifier: "sequeQuizScreen", sender: nil)
                }
            })
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        var state: Bool = false
        switch textField.tag {
        case 0:
            emailErrorLabel.alpha = 0
            emailSeparatorView.backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
            if (updatedString ?? "").count > 0 && (passwordField.text ?? "").count > 0 {
                state = true
            } else {
                state = false
            }
        case 1:
            passwordErrorLabel.alpha = 0
            passwordSeparatorView.backgroundColor = #colorLiteral(red: 0.9214683175, green: 0.921626389, blue: 0.9214584231, alpha: 1)
            if (updatedString ?? "").count > 0 && (loginField.text ?? "").count > 0 {
                state = true
            } else {
                state = false
            }
        default:
            break
        }
        signInButton.isEnabled = state ? true : false
        signInButton.backgroundColor = state ? #colorLiteral(red: 1, green: 0.6055343747, blue: 0.1803497076, alpha: 1) : #colorLiteral(red: 0.7803063989, green: 0.7804415822, blue: 0.780297935, alpha: 1)
        return true
    }
}
