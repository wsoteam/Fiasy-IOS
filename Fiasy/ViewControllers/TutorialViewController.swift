

import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

  
    @IBAction func showFirstVC(_ sender: Any) {
        
        
        if let viewController = UIStoryboard(name: "FirstScreenStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController {
            
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
}
