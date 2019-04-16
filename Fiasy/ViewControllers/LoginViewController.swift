//



import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

class LoginViewController: BaseViewController ,GIDSignInUIDelegate{
    
    
    var ref: DatabaseReference!

    
    //

    
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
     //   myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    private func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        //self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
      //  self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    
    @IBOutlet weak var signInButton: GIDSignInButton!

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private lazy var telephoneView: TelephoneView = {
        let phoneView = UINib(nibName: "TelephoneView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TelephoneView
        phoneView.clipsToBounds = true
        return phoneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init Telephone view
        ref = Database.database().reference()
        
        
        telephoneView.frame = view.frame
        telephoneView.sendButton.addTarget(self, action: #selector(self.sendSMS(_:)), for: .touchUpInside)
        telephoneView.cancelButton.addTarget(self, action: #selector(self.hidePhoneview(_:)), for: .touchUpInside)
        view.addSubview(telephoneView)
        let tapComments = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        telephoneView.isUserInteractionEnabled = true
        telephoneView.addGestureRecognizer(tapComments)
        telephoneView.isHidden = true
        /*
         @IBOutlet weak var phoneNumberField: UITextField!
         @IBOutlet weak var smsField: UITextField!
         */
        GIDSignIn.sharedInstance().uiDelegate = self


    }
   @objc func hideKeyboard(){
    
    self.view.endEditing(true)

    }
    @objc func sendSMS(_ sender: UIButton){
        
        print("\(sender)")
    
        
        if (UserDefaults.standard.value(forKey: "firebase_verification") == nil ){
        PhoneAuthProvider.provider().verifyPhoneNumber( telephoneView.phoneNumberField.text!) { (verificationID, error) in
            if ((error) != nil) {
                // Verification code not sent.
                print("Login error: \(error!.localizedDescription)")
            } else {
                // Successful. User gets verification code
                // Save verificationID in UserDefaults
                UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
                UserDefaults.standard.synchronize()
                //And show the Screen to enter the Code.
            }
            
            }
            
        }
            else
        {
            let verificationID = UserDefaults.standard.value(forKey: "firebase_verification")
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID! as! String, verificationCode:self.telephoneView.phoneNumberField.text!)
            
            Auth.auth().signIn(with: credential, completion: {(_ user: User, _ error: Error?) -> Void in
                if error != nil {
                    // Error
                    
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    
                    
                }else {
                    print("Phone number: \(user.phoneNumber)")
                    let userInfo: Any? = user.providerData[0]
                    print(userInfo)
                    
                    self.telephoneView.isHidden = true
                    self.loadHomeTabbarViewController()
                }
                } as! AuthResultCallback)
            }
            
    }
    @objc func hidePhoneview(_ sender: UIButton){
        
        print("\(sender)")
        telephoneView.isHidden = true
    }

  
    
    @IBAction func emailLogin(_ sender: Any) {
  
        
        
        Auth.auth().signIn(withEmail: loginField.text!, password: passwordField.text!) { [weak self] user, error in
        
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self!.present(alertController, animated: true, completion: nil)
                
                return
            }else
            {
                
                self!.loadHomeTabbarViewController()
            }
        }
        
   

        
    
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                self.loadHomeTabbarViewController()
                
            })
            
        }
    }
  
    
    
    @IBAction func messageLogin(_ sender: Any) {
     
        telephoneView.isHidden = false
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

        
    }
    @IBAction func showForgotPassword(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "ForgotPasswordStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

    
    @IBAction func googleSignIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()

    }
    
   
    
}
