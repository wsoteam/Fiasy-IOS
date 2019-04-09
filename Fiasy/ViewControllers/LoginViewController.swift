//


import UIKit

class LoginViewController: UIViewController {
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func emailLogin(_ sender: Any) {
  
       loadHomeTabbarViewController()
//
//        if let viewController = UIStoryboard(name: "PremiumStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "PremiumViewController") as? PremiumViewController {
//
//
//            if let navigator = navigationController {
//                navigator.pushViewController(viewController, animated: true)
//            }
//        }
        
    
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

    
    // MARK: - Load Home Tabbar
    func loadHomeTabbarViewController() {
        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
        
        //  My ViewController screen
        let myStoryboard = UIStoryboard(name: "MyViewController", bundle: Bundle.main)
        let myVC = myStoryboard.instantiateViewController(withIdentifier: "MyViewController") as! MyViewController
        
        let myTab = UITabBarItem(title: "Я", image: UIImage(named: "Vector"), selectedImage: UIImage(named: "Vector"))
        myVC.tabBarItem = myTab
        
        //  Trainer Tab
        let trainerStoryBoard = UIStoryboard(name: "TrainerStoryboard", bundle: Bundle.main)
        let trainerVC = trainerStoryBoard.instantiateViewController(withIdentifier: "TrainerViewController") as! TrainerViewController
        
        let trainerTab = UITabBarItem(title: "Тренер", image: UIImage(named: "Group 5"), selectedImage: UIImage(named: "Group 5"))
        trainerVC.tabBarItem = trainerTab
        
        
        //  CheckIn Tab
        let checkInStoryboard = UIStoryboard(name: "MainStoryboard", bundle: Bundle.main)
        let checkInVc = checkInStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let checkInTab = UITabBarItem(title: "Дневник", image: UIImage(named: "Group 2-1"), selectedImage: UIImage(named: "Group 2-1"))
        
        checkInVc.tabBarItem = checkInTab
        
        // Articles Tab
        let articlesStoryboard = UIStoryboard(name: "ArticlesStoryboard", bundle: Bundle.main)
        let articlesVc = articlesStoryboard.instantiateViewController(withIdentifier: "ArticlesViewController") as! ArticlesViewController
        let articlesTab = UITabBarItem(title: "Статьи", image: UIImage(named: "Group 2"), selectedImage: UIImage(named: "Group 2"))
        articlesVc.tabBarItem = articlesTab
        
        // Recipe Tab
        let recipeStoryBoard = UIStoryboard(name: "RecipesStoryboard", bundle: Bundle.main)
        let recipeVC = recipeStoryBoard.instantiateViewController(withIdentifier: "RecipesViewController") as! RecipesViewController
        let recipeTabTab = UITabBarItem(title: "Статьи", image: UIImage(named: "Subtract"), selectedImage: UIImage(named: "Subtract"))
        recipeVC.tabBarItem = recipeTabTab
        
        initialViewController.tabbarViewControllers = [trainerVC, trainerVC,checkInVc,articlesVc,recipeVC]
        initialViewController.navigationController?.navigationBar.isHidden = true
        let tabBarstoryboard = UIStoryboard(name: "TabBarController", bundle: nil)
        let navigationController = tabBarstoryboard.instantiateViewController(withIdentifier: "TabbarNavigationController") as! UINavigationController
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [initialViewController]
        
        self.appDelegate.window?.rootViewController = navigationController
        self.appDelegate.window?.makeKeyAndVisible()

    }
    
}
