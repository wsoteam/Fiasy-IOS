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
import FirebaseDatabase
import Amplitude_iOS
import Adjust
import Intercom

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let screensController = ScreensController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

      //  Fabric.with([Crashlytics.self()])
        Bugsee.launch(token :"dca43646-372f-498e-9251-a634c61801b1")
         
        FirebaseApp.configure()
        SQLDatabase.shared.fetchProducts()
        FirebaseDBManager.checkFilledProfile()
        SwiftGoogleTranslate.shared.start(with: "AIzaSyB5dv1L0W_85lcFrEcyqZ0KyGZeRn6wOTE")
        Amplitude.instance()?.trackingSessionEvents = true
        Amplitude.instance()?.minTimeBetweenSessionsMillis = 5000
        Amplitude.instance()?.initializeApiKey("115a722e4336d141626d680fc1cca21c")
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        screensController.showScreens()
        SubscriptionService.shared.getProducts()
        Intercom.setApiKey("221925e0d17a40eb824938ad4c2a9857e2320b6f", forAppId: "dr8zfmz4")
        
        Amplitude.instance().logEvent("session_launch")
        Adjust.appDidLaunch(ADJConfig(appToken: "9gsjine9aqyo", environment: ADJEnvironmentProduction, allowSuppressLogLevel: true))
        
        return true
    }
    
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (Auth.auth().canHandleNotification(userInfo)) {
            return print(userInfo)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication,
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
}

