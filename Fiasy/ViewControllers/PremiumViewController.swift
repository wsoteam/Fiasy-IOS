

import UIKit

class PremiumViewController: UIViewController {

    @IBOutlet weak var treeMontsBtn: UIButton!
    @IBOutlet weak var nwelveMonth: UIButton!
    @IBOutlet weak var oneMonth: UIButton!
    
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func oneMonth(_ sender: Any) {
        
        self.oneMonth.layer.borderWidth = 4.0
        self.oneMonth.layer.borderColor = UIColor(red:253/255, green:91/255, blue:28/255, alpha: 1).cgColor

        self.oneMonth.layer.masksToBounds = true
        self.nwelveMonth.layer.borderColor =  UIColor.white.cgColor
        self.treeMontsBtn.layer.borderColor =  UIColor.white.cgColor
        
    }
    @IBAction func threeMonth(_ sender: Any) {
        loadHomeTabbarViewController()
        self.treeMontsBtn.layer.borderWidth = 4.0
        self.treeMontsBtn.layer.borderColor = UIColor(red:253/255, green:91/255, blue:28/255, alpha: 1).cgColor
        self.treeMontsBtn.layer.masksToBounds = true
        
        self.nwelveMonth.layer.borderColor =  UIColor.white.cgColor
        self.oneMonth.layer.borderColor =  UIColor.white.cgColor
    }
    
    @IBAction func twelveMonth(_ sender: Any) {

        
        self.nwelveMonth.layer.borderWidth = 4.0
        self.nwelveMonth.layer.borderColor =  UIColor(red:253/255, green:91/255, blue:28/255, alpha: 1).cgColor
         self.nwelveMonth.layer.masksToBounds = true
      
        self.oneMonth.layer.borderColor =  UIColor.white.cgColor
        self.treeMontsBtn.layer.borderColor =  UIColor.white.cgColor
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
//
//        mainNavigationController = navigationController
    }

}
