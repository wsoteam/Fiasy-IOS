//
//  MainTabBarVC.swift
//  mpuaz
//
//  Created by Eugene Lipatov on 17.07.17.
//  Copyright © 2017 Eugene Lipatov. All rights reserved.
//

import UIKit

class MainTabBarVC : UITabBarController, UITabBarControllerDelegate {
    
    var tabbarViewControllers = [Any]()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.viewControllers = tabbarViewControllers  as! [UIViewController]
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        self.selectedIndex = (tabBar.items?.index(of: item))!
        
        if self.viewControllers![0] is MyViewController
        {
            if self.selectedIndex == 0 {
                let myVC = self.viewControllers![0] as! MyViewController
                
            }
        }
//
        if self.viewControllers![0] is TrainerViewController
        {
            if self.selectedIndex == 0 {
                let trainerVC = self.viewControllers![0] as! TrainerViewController

            }
        }
//
        if self.viewControllers![0] is MainViewController
        {
            if self.selectedIndex == 0 {
                let mainVC = self.viewControllers![0] as! MainViewController

            }
        }
//
        if (self.viewControllers?.count)! > 3 {
            if self.viewControllers![2] is ArticlesViewController
            {
                if self.selectedIndex == 2 {
                    let updateVC = self.viewControllers![2] as! ArticlesViewController

                }
            }
        }
        
        
        if (self.viewControllers?.count)! > 3 {
            if self.viewControllers![2] is RecipesViewController
            {
                if self.selectedIndex == 2 {
                    let updateVC = self.viewControllers![2] as! RecipesViewController
                    
                }
            }
        }
        
    }
    
    
    func openVC(vc: UIViewController) {
        (selectedViewController as? UINavigationController)?.pushViewController(vc, animated: false)
    }
}

