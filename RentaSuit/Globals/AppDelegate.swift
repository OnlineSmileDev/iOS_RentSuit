//
//  AppDelegate.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 17/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import GoogleMaps
import FBSDKShareKit
import FBSDKLoginKit
import TwitterKit
import Braintree

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var mainNavigationController : UINavigationController?
    
    fileprivate func initUI() {
        window = UIWindow (frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashScreen")
        mainNavigationController = UINavigationController (rootViewController: initialViewController)
        mainNavigationController!.isNavigationBarHidden = true
        window!.rootViewController = mainNavigationController
        window!.makeKeyAndVisible()
    }
    
    
    // logout and roll back to login / registe view
    func logout() {
        
        User.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "splashScreen")
        mainNavigationController = UINavigationController (rootViewController: vc)
        mainNavigationController!.isNavigationBarHidden = true
        window!.rootViewController = mainNavigationController
        
    }
    
    fileprivate func initSDK(){
        let infoList = Bundle.main.infoDictionary
        if nil != infoList {
            if let gmsKey = infoList?["GMS_MAPS_KEY"]! as? String {
                GMSServices.provideAPIKey(gmsKey)
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initSDK()
        initUI()
        TWTRTwitter.sharedInstance().start(withConsumerKey:twitter_app_id, consumerSecret:Twitter_secret)
      
        BTAppSwitch.setReturnURLScheme("com.dev.RentaSuit.payments")
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
         FBSDKAppEvents.activateApp()
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


    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
     
       
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
      
      if url.scheme?.localizedCaseInsensitiveCompare("com.dev.RentaSuit.payments") == .orderedSame {
          return BTAppSwitch.handleOpen(url, options: options)
      }
        
        return false
    }
}

