//



import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController ,GIDSignInUIDelegate{
    
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
    
    
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
   // @IBOutlet weak var signInButton: GIDSignInButton!

    @IBOutlet weak var signInButton: GIDSignInButton!

    
    private lazy var telephoneView: TelephoneView = {
        let phoneView = UINib(nibName: "TelephoneView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TelephoneView
        phoneView.clipsToBounds = true
        return phoneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init Telephone view
        
        telephoneView.frame = view.frame
        telephoneView.sendButton.addTarget(self, action: #selector(self.sendSMS(_:)), for: .touchUpInside)
        telephoneView.cancelButton.addTarget(self, action: #selector(self.hidePhoneview(_:)), for: .touchUpInside)
        view.addSubview(telephoneView)
        let tapComments = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        telephoneView.isUserInteractionEnabled = true
        telephoneView.addGestureRecognizer(tapComments)

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
        telephoneView.isHidden = true
    }
    @objc func hidePhoneview(_ sender: UIButton){
        
        print("\(sender)")
        telephoneView.isHidden = true
    }

    func signFaceBook()
    {
        
        
    }
    @IBAction func emailLogin(_ sender: Any) {
  
       loadHomeTabbarViewController()
//
//        if let viewController = UIStoryboard(name: "PremiumStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "PremiumViewController") as? PremiumViewController {
//
//
//            if let navigator = navigationController {
//                navigator.pushViewController(viewController, animated: true)
//            }
//        }
        
    
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
    @IBAction func googleLogin(_ sender: Any) {
        
    }
    
    @IBAction func messageLogin(_ sender: Any) {
        
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
    
    // MARK: - Load Home Tabbar
    func loadHomeTabbarViewController() {
        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
        
        //  My ViewController screen
        let myStoryboard = UIStoryboard(name: "MyViewController", bundle: Bundle.main)
        let myVC = myStoryboard.instantiateViewController(withIdentifier: "MyViewController") as! MyViewController
        
        let myTab = UITabBarItem(title: "Я", image: UIImage(named: "Vector"), selectedImage: UIImage(named: "Vector"))
        myVC.tabBarItem = myTab
        
        //  Trainer Tab
        let trainerStoryBoard = UIStoryboard(name: "TrainerStoryboard", bundle: Bundle.main)
        let trainerVC = trainerStoryBoard.instantiateViewController(withIdentifier: "TrainerViewController") as! TrainerViewController
        
        let trainerTab = UITabBarItem(title: "Тренер", image: UIImage(named: "Group 5"), selectedImage: UIImage(named: "Group 5"))
        trainerVC.tabBarItem = trainerTab
        
        
        //  CheckIn Tab
        let checkInStoryboard = UIStoryboard(name: "MainStoryboard", bundle: Bundle.main)
        let checkInVc = checkInStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let checkInTab = UITabBarItem(title: "Дневник", image: UIImage(named: "Group 2-1"), selectedImage: UIImage(named: "Group 2-1"))
        
        checkInVc.tabBarItem = checkInTab
        
        // Articles Tab
        let articlesStoryboard = UIStoryboard(name: "ArticlesStoryboard", bundle: Bundle.main)
        let articlesVc = articlesStoryboard.instantiateViewController(withIdentifier: "ArticlesViewController") as! ArticlesViewController
        let articlesTab = UITabBarItem(title: "Статьи", image: UIImage(named: "Group 2"), selectedImage: UIImage(named: "Group 2"))
        articlesVc.tabBarItem = articlesTab
        
        // Recipe Tab
        let recipeStoryBoard = UIStoryboard(name: "RecipesStoryboard", bundle: Bundle.main)
        let recipeVC = recipeStoryBoard.instantiateViewController(withIdentifier: "RecipesViewController") as! RecipesViewController
        let recipeTabTab = UITabBarItem(title: "Статьи", image: UIImage(named: "Subtract"), selectedImage: UIImage(named: "Subtract"))
        recipeVC.tabBarItem = recipeTabTab
        
        initialViewController.tabbarViewControllers = [trainerVC, trainerVC,checkInVc,articlesVc,recipeVC]
        initialViewController.navigationController?.navigationBar.isHidden = true
        let tabBarstoryboard = UIStoryboard(name: "TabBarController", bundle: nil)
        let navigationController = tabBarstoryboard.instantiateViewController(withIdentifier: "TabbarNavigationController") as! UINavigationController
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [initialViewController]
        
        self.appDelegate.window?.rootViewController = navigationController
        self.appDelegate.window?.makeKeyAndVisible()

    }
    
}
