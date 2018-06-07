//
//  AppDelegate.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 22/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import Firebase
import DualSlideMenu
import MBProgressHUD
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        self.registerForPushNotifications(application: application)
        
        self.setRootController()

        UIApplication.shared.statusBarStyle = .lightContent
        
        // Override point for customization after application launch.
        return true
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
    }

}

extension AppDelegate:UNUserNotificationCenterDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
}

extension AppDelegate{
    
    func registerForPushNotifications(application:UIApplication){
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func setRootController(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let leftView = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: "LeftMenuController")
        let rightView = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: "RightMenuController")
        let mainView = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: "MainController")
        
        Constants.sideMenuController = DualSlideMenuViewController(mainViewController: mainView, leftMenuViewController: leftView, rightMenuViewController: rightView)
        Constants.sideMenuController.leftSideOffset = 100
        Constants.sideMenuController.rightSideOffset = 100
        Constants.sideMenuController.addSwipeGestureInSide(viewController: rightView, direction: .right)
        Constants.sideMenuController.addSwipeGestureInSide(viewController: leftView, direction: .left)
        window!.rootViewController = Constants.sideMenuController
        window!.makeKeyAndVisible()
        
    }
    
}

