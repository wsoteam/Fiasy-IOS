

import UIKit

class RegestrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        

    }
    

    @IBAction func regestrationAction(_ sender: Any) {
        

        
        if let viewController = UIStoryboard(name: "TutorialStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
}
