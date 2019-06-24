//
//  MenuViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MenuViewController: UITabBarController {
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = UIColor(red: 211/255.0, green: 143/255.0, blue: 68/255.0, alpha: 1.0)
        
        guard let _ = UserDefaults.standard.value(forKey: "firstShowMenuView") else {
            UserDefaults.standard.set(true, forKey: "firstShowMenuView")
            UserDefaults.standard.synchronize()
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(didRecieveLogoutNotification), Constant.LOG_OUT)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    @objc func didRecieveLogoutNotification() {
        performSegue(withIdentifier: "segueToAuth", sender: nil)
    }
}