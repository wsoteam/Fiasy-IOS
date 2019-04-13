


import Foundation
import UIKit

class AlertComponent {
    static let sharedInctance = AlertComponent()
    
    var textField: UITextField!
    
    func showMessage(message: String?, handler: ((UIAlertAction) -> Void)?, vc: UIViewController) {
        let alertController = UIAlertController(title: message,
                                                message: "",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showTitleAndMessage(title: String? ,message: String?, handler: ((UIAlertAction) -> Void)?, vc: UIViewController) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showInternetErrorAlert(vc: UIViewController, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Internet error",
                                                message: "Please check the internet connection",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }

    
    func choosenMessage(message: String?, handler: ((UIAlertAction) -> Void)?, vc: UIViewController) {
        let alertController = UIAlertController(title: message,
                                                message: "",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: handler)
        let noOkAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(noOkAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAndTextField(message: String?, handler: @escaping ((String) -> ()), vc: UIViewController) {
        let alertController = UIAlertController(title: "Enter Input",
                                                message: "",
                                                preferredStyle: .alert)
        alertController.addTextField(configurationHandler: configurationTextField)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler:{ (UIAlertAction) in
            handler(self.textField.text!)
        }))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func configurationTextField(textField: UITextField!) {
        print("generating the TextField")
        textField.placeholder = "Enter password"
        self.textField = textField
    }
}
