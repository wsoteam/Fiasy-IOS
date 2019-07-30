import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class FirstViewController: UIViewController {
    
    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    // MARK: - Private -
    private func checkFirstLoad() {
//        guard let _ = UserDefaults.standard.value(forKey: "firstLoadComplete") else {
//            return performSegue(withIdentifier: "segueSecondUserInfoScreen", sender: nil)
//        }
    }
    
    // MARK: - Action's -
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
                        return AlertComponent.sharedInctance.showAlertMessage(title: "Ошибка",
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
}

extension FirstViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dismissing Google SignIn")
    }
    
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
