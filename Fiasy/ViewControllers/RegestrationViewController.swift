

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class RegestrationViewController: BaseViewController, GIDSignInUIDelegate{

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
    
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    private lazy var telephoneView: TelephoneView = {
        let phoneView = UINib(nibName: "TelephoneView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TelephoneView
        phoneView.clipsToBounds = true
        return phoneView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Telephone view
         telephoneView.isHidden = true
        telephoneView.frame = view.frame
        telephoneView.sendButton.addTarget(self, action: #selector(self.sendSMSM(_:)), for: .touchUpInside)
        telephoneView.cancelButton.addTarget(self, action: #selector(self.hidePhoneview(_:)), for: .touchUpInside)
        view.addSubview(telephoneView)
        
        
        let tapComments = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        telephoneView.isUserInteractionEnabled = true
        telephoneView.addGestureRecognizer(tapComments)
         GIDSignIn.sharedInstance().uiDelegate = self
        /*
         @IBOutlet weak var phoneNumberField: UITextField!
         @IBOutlet weak var smsField: UITextField!
         */
    }

    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
        
    }
  
    
    @objc func hidePhoneview(_ sender: UIButton){
        
        print("\(sender)")
        telephoneView.isHidden = true
    }

    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func messageLogin(_ sender: Any) {
        
        telephoneView.isHidden = false
    }
    
    @IBAction func regestrationAction(_ sender: Any) {
        if isConnectedToNetwork() == true {
            
        
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!){ (user, error) in
                if error == nil {
                    
                    print(user)
                    
                            if let viewController = UIStoryboard(name: "TutorialStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController {
                                self.navigationController?.pushViewController(viewController, animated: true)
                                
                            }                }
                    
                else{
                    let alertController = UIAlertController(title: "Такой пользователь уже существует", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
      }
    }
    
    @IBAction func facebookRegistration(_ sender: Any)
    {
        if isConnectedToNetwork() == true {
            
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
    }
    
    
   
    
    
    
    @IBAction func googleRegistration(_ sender: Any)
    {
        if isConnectedToNetwork() == true {
            
            GIDSignIn.sharedInstance().signIn()
            
        }
    }
 
    @objc func sendSMSM(_ sender: UIButton){
        
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

}
