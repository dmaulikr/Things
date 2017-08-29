//
//  AppDelegate.swift
//  Things
//
//  Created by Brie Heutmaker on 11/18/15.
//  Copyright © 2015 Brie Heutmaker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coordinator: Coordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        coordinator = Coordinator()
        UITabBar.appearance().tintColor = UIColor.purple
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if Auth.auth().currentUser != nil {
            // User is signed in. Show All The Things.
            AppState.shared.signedIn = true
            
            let initialViewController = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = initialViewController
        
        } else {
            // User not signed in. Show Splash page
            AppState.shared.signedIn = false
            
            guard let splashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController else { fatalError() }
            
            splashViewController.coordinator = coordinator
            self.window?.rootViewController = splashViewController
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        
        return true
    }
}

