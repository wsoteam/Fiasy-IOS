//


import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func emailLogin(_ sender: Any) {
  
        
        
        if let viewController = UIStoryboard(name: "PremiumStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "PremiumViewController") as? PremiumViewController {
            
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    
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

}
