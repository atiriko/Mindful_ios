//
//  AppDelegate.swift
//  Motivation
//
//  Created by Atahan Sahlan on 01/10/2020.
//

import UIKit
import Firebase
import BackgroundTasks
import WidgetKit
import GoogleMobileAds
import GoogleSignIn
import FBSDKCoreKit





@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        print(error)
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
     Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
          let authError = error as NSError
//
          return
        }
     }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
      return GIDSignIn.sharedInstance().handle(url)
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //registerBackgroundTasks()
        registerBackgroundTaks()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = kGADSimulatorID as? [String]
        //testDeviceIdentifiers = @[ kGADSimulatorID ];
      
        setupNotifications(on: application)
        
        

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //submitBackgroundTasks()
        scheduleQuotefetcher()
      }
    private func registerBackgroundTaks() {

  
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.motivation.getQuotes", using: nil) { task in
    //This task is cast with processing request (BGAppRefreshTask)
   
    }
    }
    func scheduleQuotefetcher() {
    let request = BGProcessingTaskRequest(identifier: "com.motivation.getQuotes")
    request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
    request.requiresExternalPower = false
    //If we keep requiredExternalPower = true then it required device is connected to external power.

    request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // fetch Image Count after 1 minute.
    //Note :: EarliestBeginDate should not be set to too far into the future.
    do {
        print("calisti")
        getQuotes()
    try BGTaskScheduler.shared.submit(request)
    } catch {
    print("Could not schedule image fetch: (error)")
    }
    }
    func handleAppRefresh(task: BGAppRefreshTask) {
       // Schedule a new refresh task
        scheduleQuotefetcher()

       // Create an operation that performs the main part of the background task
         getQuotes()

       
       // Provide an expiration handler for the background task
       // that cancels the operation
      

       // Inform the system that the background task is complete
       // when the operation completes
//       operation.completionBlock = {
//          task.setTaskCompleted(success: !operation.isCancelled)
//       }
//
//       // Start the operation
//       operationQueue.addOperation(operation)
     }

   
    func submitBackgroundTasks() {
        // Declared at the "Permitted background task scheduler identifiers" in info.plist
        let backgroundAppRefreshTaskSchedulerIdentifier = "com.motivation.getQuotes"
        
        let timeDelay = 10.0

        do {
          let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: backgroundAppRefreshTaskSchedulerIdentifier)
          backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeDelay)
          try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
          print("Submitted task request")
        } catch {
          print("Failed to submit BGTask")
        }
      }
    func registerBackgroundTasks() {
        // Declared at the "Permitted background task scheduler identifiers" in info.plist
        let backgroundAppRefreshTaskSchedulerIdentifier = "com.motivation.getQuotes"

        // Use the identifier which represents your needs
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
           print("BackgroundAppRefreshTaskScheduler is executed NOW!")
           print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
           task.expirationHandler = {
             task.setTaskCompleted(success: false)
           }
            self.getQuotes()
           // Do some data fetching and call setTaskCompleted(success:) asap!
    //       let isFetchingSuccess = true
      //     task.setTaskCompleted(success: isFetchingSuccess)
         }
       }
    func getQuotes(){
        let number = Int.random(in: 0..<47391)


        database().getQuote(number: number){(quote)in
           
            
            self.userDefaults?.set(quote.text! as String, forKey: "QuoteText")
            self.userDefaults?.set(quote.author! as String, forKey: "QuoteAuthor")
            self.userDefaults?.synchronize()
           
          
                WidgetCenter.shared.reloadAllTimelines()
        }

            
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
extension AppDelegate {
    func setupNotifications(on application: UIApplication) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Failed to request autorization for notification center: \(error.localizedDescription)")
                return
            }
            guard granted else {
                print("Failed to request autorization for notification center: not granted")
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        let bundleID = Bundle.main.bundleIdentifier
        print("Bundle ID: \(token) \(String(describing: bundleID))")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .badge, .sound])
        //completionHandler(.list)
               // banner
          //     completionHandler(.banner)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        
        let content = response.notification.request.content
      
        
        if let userInfo = content.userInfo as? [String: Any],
            let aps = userInfo["aps"] as? [String: Any] {
            print("aps: \(aps)")
        }
    }
    
}

