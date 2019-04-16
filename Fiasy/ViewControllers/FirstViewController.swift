

import UIKit

class FirstViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadHomeTabbarViewController()
    }
    

    @IBAction func regestration(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "RegistrationProfileStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RegistrationProfileViewController") as? RegistrationProfileViewController {
          
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func showLoginScreen(_ sender: Any) {
        if let viewController = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {

            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
}
