//
//  RHSCAppDelegate.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-30.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//


import Foundation
import UIKit

@UIApplicationMain class RHSCAppDelegate : UIResponder,UIApplicationDelegate {

    var window : UIWindow? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // _window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
        showLogonScreen()
        return true
    }
    
    func showLogonScreen() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle:nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Logon") as! RHSCLogonViewController
        window?.makeKeyAndVisible()
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
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
    }
    

}
