//
//  AppDelegate.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 3/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics
import Fabric
import FBSDKCoreKit
import Firebase
import Bugsee
import GoogleSignIn



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
//            _ = user.userID                  // For client-side use only!
//            _ = user.authentication.idToken // Safe to send to the server
//            _ = user.profile.name
//            _ = user.profile.givenName
//            _ = user.profile.familyName
//            _ = user.profile.email
            // ...
            self.loadHomeTabbarViewController()
        }
    }
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

      //  Fabric.with([Crashlytics.self()])
        Bugsee.launch(token :"dca43646-372f-498e-9251-a634c61801b1")
       // GIDSignIn.sharedInstance().clientID = "588344798889-ucqhmdmq5m5isj591c2rl6ul6fuqp36a.apps.googleusercontent.com"
        //GIDSignIn.sharedInstance().delegate = self

        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        
        return true
    }
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options) //SDKApplicationDelegate.shared.application(app, open: url, options: options)
//    }

    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Fiasy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Load Home Tabbar
    func loadHomeTabbarViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
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
        
     window?.rootViewController = navigationController
       window?.makeKeyAndVisible()
        
    }
    
}

