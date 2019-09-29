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
import FacebookCore
import GoogleSignIn
import FirebaseDatabase
import Amplitude_iOS
import UserNotifications
import Adjust
import Intercom

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let screensController = ScreensController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        DispatchQueue.global().async {
//            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
//        }
       
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

      //  Fabric.with([Crashlytics.self()])
        //Bugsee.launch(token :"9dd1f372-d496-4bef-ac70-0ff732d0b82b")
        
        FirebaseApp.configure()
        FirebaseDBManager.checkFilledProfile { (state) in }
        //SwiftGoogleTranslate.shared.start(with: "AIzaSyB5dv1L0W_85lcFrEcyqZ0KyGZeRn6wOTE")
        Amplitude.instance()?.trackingSessionEvents = true
        Amplitude.instance()?.minTimeBetweenSessionsMillis = 5000
        Amplitude.instance()?.initializeApiKey("b148a2e64cc862b4efb10865dfd4d579")
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        screensController.showScreens()
        SubscriptionService.shared.getProducts()

        Intercom.setApiKey("ios_sdk-221925e0d17a40eb824938ad4c2a9857e2320b6f", forAppId:"dr8zfmz4")
        Adjust.appDidLaunch(ADJConfig(appToken: "8qzg30s9d3wg", environment: ADJEnvironmentProduction, allowSuppressLogLevel: true))

        if let uid = Auth.auth().currentUser?.uid {
            Intercom.registerUser(withUserId: uid)
        } else {
            Intercom.registerUnidentifiedUser()
        }
        return true
    }
    
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (Intercom.isIntercomPushNotification(userInfo)) {
            Intercom.handlePushNotification(userInfo)
        }
//        if (Auth.auth().canHandleNotification(userInfo)) {
//            return print(userInfo)
//        }
        completionHandler(.noData);
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        Adjust.trackSubsessionStart()
        
        if let _ = UIApplication.getTopMostViewController() as? QuizViewController {
            Intercom.logEvent(withName: "onboarding_success", metaData: ["from" : "reopen"]) // +
            Amplitude.instance()?.logEvent("onboarding_success", withEventProperties: ["from" : "reopen"]) // +
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Adjust.trackSubsessionEnd()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
        Intercom.setDeviceToken(deviceToken)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        if let _ = UIApplication.getTopMostViewController() as? QuizViewController {
            UserDefaults.standard.set(true, forKey: "showQuizView")
            UserDefaults.standard.synchronize()
        }
        self.saveContext()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication,
                                                        annotation: annotation)
    }

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

