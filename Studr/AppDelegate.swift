//
//  AppDelegate.swift
//  Studr
//
//  Created by Joshua Herkness on 10/31/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps
import MMDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Parse Application ID
        Parse.setApplicationId("SiUI7l8keFbkruaPeGJGFysV1QRvFh8doFEIDn46", clientKey: "uIRt8lWTeyYLRUXUoWdZHoIQEN289OripAM6ucRh")
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotifications()
        }
        
        // Google Maps API Key
        GMSServices.provideAPIKey("AIzaSyBNOeTdFtSuG1DjZ6j5WUv-a2KOD-elG_g")
        
        //authenticatedUser: check from NSUserDefaults User credential if its present then set your navigation flow accordingly
        
        //UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UITextField.appearance().keyboardAppearance = .Light
        UILabel.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = UIColor.blackColor().colorWithAlphaComponent(0.3)

        // Determine wether to authenticate the user
        var rootViewController = UIViewController()
        if let _ = PFUser.currentUser() {
            let sideViewController = SideMenuViewController()
            let centerViewController = UINavigationController(rootViewController: GroupsViewController())
            let drawerController = DrawerController(centerViewController: centerViewController, leftDrawerViewController: sideViewController)
            
            rootViewController = drawerController
            
        } else {
            // Authenticate the user
            rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("OnboardingViewController")
        }
        
        // Display the root view controller
        if let window = self.window {
            window.rootViewController? = rootViewController
            window.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //Mark - Notification
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

}

