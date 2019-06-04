import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

class LoginViewController: BaseViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Properties -
    private let ref: DatabaseReference = Database.database().reference()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
    }

    //MARK: - Actions -
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emailLogin(_ sender: Any) {
        guard let email = loginField.text, let password = passwordField.text, !email.isEmpty && !password.isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Заполните поля", vc: self)
        }
        
        guard email.isValidEmail() else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Проверьте введенный email!", vc: self)
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if let error = error {
                if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    return AlertComponent.sharedInctance.showAlertMessage(title: "",
                            message: "Пользователь не существует", vc: strongSelf)
                } else {
                    return AlertComponent.sharedInctance.showAlertMessage(title: "",
                            message: "Проверьте введенный пароль", vc: strongSelf)
                }
            } else {
                if Auth.auth().currentUser != nil {
                    FirebaseDBManager.checkFilledProfile()
                    self?.performSegue(withIdentifier: "segueToMenu", sender: nil)
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
                FirebaseDBManager.checkFilledProfile()
                self.performSegue(withIdentifier: "segueToMenu", sender: nil)
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
}

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            guard error.localizedDescription != "The user canceled the sign-in flow." else {
                return
            }
            return AlertComponent.sharedInctance.showAlertMessage(title: "Login Error",
                                                         message: error.localizedDescription, vc: self)
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    return AlertComponent.sharedInctance.showAlertMessage(title: "Login Error",
                                    message: error.localizedDescription, vc: strongSelf)
                } else {
                    FirebaseDBManager.checkFilledProfile()
                    strongSelf.performSegue(withIdentifier: "segueToMenu", sender: nil)
                }
            })
        }
    }
}
