

import UIKit
import Foundation
import SystemConfiguration
class BaseViewController: UIViewController {
   
    //let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!


    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isHidden = false
        
     //   setupDissmissTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
   
    
    // MARK: - DismissKeyboard
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    // MARK: - DiviceModel
    func diviceModel() -> String {
        let height = UIScreen.main.bounds.height
        
        if height < 568 {
            return "4"
        } else if height == 568 {
            return "5"
        } else if height == 667 {
            return "6"
        } else if height == 736 {
            return "6+"
        } else {
            return "x"
        }
    }
    
    // MARK: - Get DateString
    func getDateString(myDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // edited
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "EEEE, MMM dd, yyyy, h:mm a"
        
        let dateString = dateFormatter.string(from:date)
        return dateString
    }

//    // MARK: - Show AlertInternetError
    func showInternetError() {
        AlertComponent.sharedInctance.showInternetErrorAlert(vc: self) { (action) in

        }
    }

//    func isConnectedToNetwork() -> Bool {
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//            }
//        }
//
//        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
//            print("")
//        }
//
//        // Working for Cellular and WIFI
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        _ = (isReachable && !needsConnection)
//
//        return isReachable
//    }
    
    // MARK: - Get Screen Shot
    func captureScreen() -> UIImage {
        var window: UIWindow? = UIApplication.shared.keyWindow
        window = UIApplication.shared.windows[0]
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, window!.isOpaque, 0.0)
        window!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }
}

//extension BaseViewController: UIGestureRecognizerDelegate {
//    // MARK: - DismissKeyboard
//    func setupDissmissTapGesture() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
//        tap.delegate = self
//        view.isUserInteractionEnabled = true;
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            print("")
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        _ = (isReachable && !needsConnection)
        
        return isReachable
    }
}
