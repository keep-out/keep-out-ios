//
//  AppDelegate.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/14/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import ChameleonFramework
import SwiftyBeaver
import Firebase
import Flurry_iOS_SDK

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Flurry analytics
        Flurry.startSession("8JTPQV36DJ87CC32C77Y", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        // Set navbar item color and background color
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = FlatGreen()
        
        // Set navbar title text color
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        // Set the console and log file destination for the
        // SwiftyBeaver loggin framework
        let console = ConsoleDestination()
        let file = FileDestination()
        
        // Set format for logger
        console.format = "$DHH:mm:ss$d $L $M"
        
        log.addDestination(console)
        log.addDestination(file)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let token = self.defaults.object(forKey: "token")
        if token == nil {
            // Set root view controller to login view
            let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = loginViewController
        } else {
            // Set root view controller to home view
            let tabBarViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
            self.window?.rootViewController = tabBarViewController
        }
        self.window?.makeKeyAndVisible()
        
        // Twitter init
        TWTRTwitter.sharedInstance().start(withConsumerKey:"B1vBU6xSkzSHdIXNSdmTykril", consumerSecret:"oOTtJR1FFdbBExnIcW5T2Oy11jKhttd5qWcGLCcLNgNHqfGoD4")
        
        log.info("Application started")
        
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

