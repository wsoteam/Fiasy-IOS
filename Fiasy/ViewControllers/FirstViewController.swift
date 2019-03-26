

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func regestration(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "RegestrationStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RegestrationViewController") as? RegestrationViewController {
          
            
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
