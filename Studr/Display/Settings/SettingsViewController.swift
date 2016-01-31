//
//  SettingsViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Parse
import Haneke

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Settings"
        
        // Create the form
        form +++ Section("")
            <<< ButtonRow("editProfile") {
                $0.title = "Edit Profile"
                $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return EditProfileViewController() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
                }
        
        form +++ Section("ADVANCED")
            <<< SwitchRow("pushNotificationSwitch"){
                $0.title = "Push Notifications"
                }.onChange{ row in
                    // TODO: Toggle notifications here
                }
            <<< SwitchRow("appBadgeSwitch"){
                $0.title = "App Bagde"
                }.onChange{ row in
                    // TODO: Toggle app badge here
                }
            <<< ButtonRow("clearCache") {
                $0.title = "Clear Cache"
                }.cellSetup { cell, row in
                    cell.tintColor = Constants.Color.primary
                }.cellUpdate{ cell, row in
                    cell.textLabel?.textAlignment = .Left
                }.onCellSelection { cell, row in
                    Shared.imageCache.removeAll()
                    Shared.dataCache.removeAll()
                    Shared.JSONCache.removeAll()
                    Shared.stringCache.removeAll()
                }
        
        form +++ Section("OTHER GREAT STUFF")
            <<< ButtonRow("about") {
                    $0.title = "About"
                    $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return AboutViewController() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
                    }
        
        form +++ Section("STUD BUD")
            <<< ButtonRow("signOut") {
                $0.title = "Log Out"
                }.cellSetup { cell, row in
                    cell.tintColor = Constants.Color.primary
                }.cellUpdate{ cell, row in
                    cell.textLabel?.textAlignment = .Left
                }.onCellSelection { cell, row in
                    self.signOut(true)
                }
    }
    
    // MARK: Functions
    
    private func signOut(requireVerification: Bool = false){
        
        // Sign out handler
        func signOut(alert: UIAlertAction!) {
            
            PFUser.logOutInBackgroundWithBlock { (error) -> Void in
                
                // Check if sign out is successfull
                if (error == nil) {
                    
                    // Return user to sign in view
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let logInViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("OnboardingViewController")
                    
                    self.presentViewController(logInViewController, animated: true, completion: {
                        appDelegate.window?.rootViewController = logInViewController
                    })
                    
                } else {
                    
                    // Error notification
                    let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorAlert.addAction(OKAction)
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                    
                }
            }
        }
        
        if (requireVerification) {
            // Error notification
            let verificationAlert = UIAlertController(title: "Sign Out", message: "Are you would like to sign out of Studr?", preferredStyle: .Alert)
            verificationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            verificationAlert.addAction(UIAlertAction(title: "Sign Out", style: .Destructive, handler: signOut))
            presentViewController(verificationAlert, animated: true, completion: nil)
        } else {
            signOut(nil)
        }
    }
}