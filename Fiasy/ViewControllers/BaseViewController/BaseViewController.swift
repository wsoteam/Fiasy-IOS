

import UIKit
import Foundation
import NVActivityIndicatorView
import SystemConfiguration
class BaseViewController: UIViewController {
   
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:  0, y: 0, width: 150, height: 150))
    var isShowPlaceholder = false
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!


    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func showPreloader(isShow: Bool)
   {

        if isShow == true && isShowPlaceholder == false
        {
            isShowPlaceholder = true
            self.view.isUserInteractionEnabled = false
            let frame = CGRect(x:  0, y: 0, width: 80, height: 80)

            
           let activityIndicatorView = NVActivityIndicatorView(frame: frame)
         
            activityIndicatorView.type = . ballScale // add your type
            activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
            activityIndicatorView.padding = 20
            activityIndicatorView.layer.zPosition = 11
            activityIndicatorView.backgroundColor = UIColor.lightGray
            activityIndicatorView.layer.cornerRadius = 10

            if !activityIndicatorView.isAnimating
            {
                self.view.addSubview(activityIndicatorView)
                activityIndicatorView.startAnimating()
            }
        } else if isShow == false && isShowPlaceholder == true {
            isShowPlaceholder = false

            for subview in self.view.subviews
            {
                if let item = subview as? NVActivityIndicatorView
                {
                    item.stopAnimating()
                    item.removeFromSuperview()

                }
            }

            self.view.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()

        }
    
    }
    
    // MARK: - DismissKeyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
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

    // MARK: - Load Home Tabbar
    func loadHomeTabbarViewController() {
        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
        
        //  My ViewController screen
        let myStoryboard = UIStoryboard(name: "MainStoryboard", bundle: Bundle.main)
        let myVC = myStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        let myTab = UITabBarItem(title: "Дневник", image: UIImage(named: "Exclude1"), selectedImage: UIImage(named: "Exclude1"))
        myVC.tabBarItem = myTab
        
        //  Trainer Tab
        let trainerStoryBoard = UIStoryboard(name: "TrainerStoryboard", bundle: Bundle.main)
        let trainerVC = trainerStoryBoard.instantiateViewController(withIdentifier: "TrainerViewController") as! TrainerViewController
        
        let trainerTab = UITabBarItem(title: "Статьи", image: UIImage(named: "Vector2"), selectedImage: UIImage(named: "Vector2"))
        trainerVC.tabBarItem = trainerTab
        
        
        //  CheckIn Tab
        let checkInStoryboard = UIStoryboard(name: "MainStoryboard", bundle: Bundle.main)
        let checkInVc = checkInStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let checkInTab = UITabBarItem(title: "Тренер", image: UIImage(named: "Group 2-1"), selectedImage: UIImage(named: "Group 2-1"))
        
        checkInVc.tabBarItem = checkInTab
        
        // Articles Tab
        let articlesStoryboard = UIStoryboard(name: "ArticlesStoryboard", bundle: Bundle.main)
        let articlesVc = articlesStoryboard.instantiateViewController(withIdentifier: "ArticlesViewController") as! ArticlesViewController
        let articlesTab = UITabBarItem(title: "Рецепты", image: UIImage(named: "Group 2"), selectedImage: UIImage(named: "Group 2"))
        articlesVc.tabBarItem = articlesTab
        
        // Recipe Tab
        let recipeStoryBoard = UIStoryboard(name: "RecipesStoryboard", bundle: Bundle.main)
        let recipeVC = recipeStoryBoard.instantiateViewController(withIdentifier: "RecipesViewController") as! RecipesViewController
        let recipeTabTab = UITabBarItem(title: "Профиль", image: UIImage(named: "Subtract"), selectedImage: UIImage(named: "Subtract"))
        recipeVC.tabBarItem = recipeTabTab
        
        initialViewController.tabbarViewControllers = [myVC, trainerVC,checkInVc,articlesVc,recipeVC]
        
        
        initialViewController.navigationController?.navigationBar.isHidden = true
        
        let tabBarstoryboard = UIStoryboard(name: "TabBarController", bundle: nil)
        let navigationController = tabBarstoryboard.instantiateViewController(withIdentifier: "TabbarNavigationController") as! UINavigationController

        navigationController.viewControllers = [initialViewController]
        
        self.appDelegate.window?.rootViewController = navigationController
        self.appDelegate.window?.makeKeyAndVisible()
        
    }
//    // MARK: - Show AlertInternetError
    func showInternetError() {
        AlertComponent.sharedInctance.showInternetErrorAlert(vc: self) { (action) in

        }
    }

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

extension BaseViewController: UIGestureRecognizerDelegate {
    // MARK: - DismissKeyboard
    func setupDissmissTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
