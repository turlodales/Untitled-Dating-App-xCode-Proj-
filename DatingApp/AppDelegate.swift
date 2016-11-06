//
//  AppDelegate.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var storyboard : UIStoryboard = {
        let stboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return stboard
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        

        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "token")
        {
           showMain()
        } else {
            showRegister()
        }
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketIOManager.sharedInstance.establishConnection()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
    }
    
    func showRegister() -> Void
    {
        
        let lognVC = self.storyboard.instantiateViewController(withIdentifier: "register")
        self.window?.rootViewController = UINavigationController(rootViewController: lognVC)
    }
    
    func showMain() -> Void
    {
        
        let lognVC = self.storyboard.instantiateViewController(withIdentifier: "main")
        self.window?.rootViewController = UINavigationController(rootViewController: lognVC)
    }

    
}

