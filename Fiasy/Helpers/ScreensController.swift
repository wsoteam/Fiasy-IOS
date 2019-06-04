//
//  ScreensController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Amplitude_iOS

class ScreensController: NSObject {
    
    //MARK: - Properties -
    private var window: UIWindow?
    
    //MARK: - Interface -
    func showScreens() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let _ = UserDefaults.standard.value(forKey: "firstShowMenuView"), Auth.auth().currentUser != nil else {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error while signing out!")
            }
            updateRootController(with: UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController())
            return setFirstLaunch()
        }

        if Auth.auth().currentUser != nil {
            updateRootController(with: UIStoryboard(name: "Menu", bundle: nil).instantiateInitialViewController())
        } else {
            updateRootController(with: UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController())
        }
        
        setFirstLaunch()
    }
    
    private func setFirstLaunch() {
        guard let _ = UserDefaults.standard.value(forKey: "authVerificationID") else {
            UserDefaults.standard.set(true, forKey: "first_launch")
            UserDefaults.standard.synchronize()
            return Amplitude.instance().logEvent("first_launch")
        }
    }

    private func updateRootController(with presenter: UIViewController?) {
        window?.rootViewController = nil
        window?.rootViewController = presenter
        window?.makeKeyAndVisible()
    }
}
