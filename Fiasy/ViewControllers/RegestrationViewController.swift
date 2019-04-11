

import UIKit
import Firebase

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
    }
    
    func googleRegistration(_ sender: Any) {
    }

}
