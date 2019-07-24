import UIKit

class FirstViewController: BaseViewController {
    
    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Private -
    private func checkFirstLoad() {
//        guard let _ = UserDefaults.standard.value(forKey: "firstLoadComplete") else {
//            return performSegue(withIdentifier: "segueSecondUserInfoScreen", sender: nil)
//        }
    }
    
    // MARK: - Action's -
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "segueUserInfoScreen", sender: nil)
    }
}
