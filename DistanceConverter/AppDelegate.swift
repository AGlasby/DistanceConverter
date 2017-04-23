//
//  AppDelegate.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 30/11/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit
import AirshipKit
import UserNotifications

var dataController: AFGDataController?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        dataController = AFGDataController() {
            (inError) in
            if let error = inError {
                self.displayError(error)
            } else {
                self.contextInitialized()
            }
        }

        guard let tabBarController = window?.rootViewController as? UITabBarController else {
            fatalError("Root view controller is not a tab bar controller")
        }
        tabBarController.selectedIndex = 0
        guard let controller = tabBarController.selectedViewController as? BlogViewController else {
            fatalError("Top view controller is not BlogViewController \(String(describing: tabBarController.selectedViewController.self))")
        }

        controller.managedObjectContext = dataController?.mainContext

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        }
        application.registerForRemoteNotifications()

        let config: UAConfig = UAConfig.default()
        if (config.validate() != true) {
            showInvalidConfigAlert()
            return true
        }

        UAirship.setLogLevel(UALogLevel.trace)

        config.messageCenterStyleConfig = "UAMessageCenterDefaultStyle"

        // Call takeOff
        UAirship.takeOff(config)
        UAirship.push().userPushNotificationsEnabled = true
        UAirship.push().defaultPresentationOptions = [.alert, .badge, .sound]
        UAirship.push().resetBadge()
        
        return true
    }

    func contextInitialized() {

    }

    func displayError(_ error: Error) {
        var message = "The database is either corrupt or was created by a"
        message += " newer version of the application. Please contact support to"
        message += " assist with this error. \n\(error.localizedDescription)"
        let alert = UIAlertController(title: "Error", message: message,
                                      preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .cancel, handler: {
            (action) in

            //Probably terminate the application
        })
        alert.addAction(close)
        if let controller = window?.rootViewController {
            controller.present(alert, animated: true, completion: nil)
        }
    }

    func showInvalidConfigAlert() {
        let alertController = UIAlertController.init(title: "Invalid AirshipConfig.plist", message: "The AirshipConfig.plist must be a part of the app bundle and include a valid appkey and secret for the selected production level.", preferredStyle:.actionSheet)
        alertController.addAction(UIAlertAction.init(title: "Exit Application", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            exit(1)
        }))

        DispatchQueue.main.async {
            alertController.popoverPresentationController?.sourceView = self.window?.rootViewController?.view

            self.window?.rootViewController?.present(alertController, animated:true, completion: nil)
        }
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
        UAirship.push().resetBadge()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

