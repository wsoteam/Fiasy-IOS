import UIKit
import Amplitude_iOS

class PremiumViewController: UIViewController {

    //MARK: - Outlet -
    

    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Amplitude.instance()?.logEvent("view_prem")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(paymentComplete), Constant.PAYMENT_COMPLETE)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    @objc func paymentComplete() {
        UserInfo.sharedInstance.paymentComplete = true
        DispatchQueue.global().async {
            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
        }
        dismiss(animated: true)
    }
    
    //MARK: - Action's -
    @IBAction func closeClicled(_ sender: Any) {
        Amplitude.instance()?.logEvent("close_premium")
        dismiss(animated: true)
    }
    
    @IBAction func purchedClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("click_on_buy")
        SubscriptionService.shared.purchase()
    }
}
