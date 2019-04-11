

import UIKit
import Firebase
import FacebookLogin

class RegestrationViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewWillDisappear(_ animated: Bool) {
         // Show the navigation bar on other view controllers
     }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        

    }
    

    @IBAction func regestrationAction(_ sender: Any) {
        
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
    
        

        
 
    
    func facebookRegistration(_ sender: Any) {
        
        if isConnectedToNetwork() == true {
            
            
            FacebookManager.sharedInstance.login(viewController: self,
                                                 success: { (result) in
                                                    NetworkManager.sharedInstance.authWithFacebook(token:result as! String,
                                                                                                   successBlock: { (response) in
                                                                                                    if let jsonResult = response as? Dictionary<String, AnyObject> {
                                                                                                        let isNewUser: Bool = (jsonResult["new-user"] as? Bool)!
                                                                                                        UserDefaults.standard.set(jsonResult[authToken], forKey: authToken)
                                                                                                        UserDefaults.standard.set(jsonResult[renewToken], forKey: renewToken)
                                                                                                        UserDefaults.standard.synchronize()
                                                                                                        
                                                                                                        print("TOKEN: %@",UserDefaults.standard.set(jsonResult["auth-token"], forKey: "auth-token"))
                                                                                                        
                                                                                                        if isNewUser == true {
                                                                                                            self.showChooseTeamVC()
                                                                                                        } else {
                                                                                                            ProfileManager.sharedInstance.setIsUserChooseTeam()
                                                                                                            self.showHomeVC()
                                                                                                        }
                                                                                                    }
                                                                                                    
                                                                                                    NetworkManager.sharedInstance.registerDevice(successBlock: { (responce) in
                                                                                                        print(responce)
                                                                                                    },
                                                                                                                                                 failureBlock: { (error) in
                                                                                                                                                    print(error)
                                                                                                    })
                                                    },
                                                                                                   failureBlock: { (error) in
                                                                                                    AlertComponent.sharedInctance.showMessage(message: "Invalid email or password",
                                                                                                                                              handler: { (action) in
                                                                                                                                                
                                                                                                    },
                                                                                                                                              vc: self)
                                                    })
            }) { (error) in
                
                print(error)
            }
        } else {
            showInternetError()
        }
        
    }
    
    func googleRegistration(_ sender: Any) {
    }

}
