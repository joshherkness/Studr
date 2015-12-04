//
//  SettingsViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Parse

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = STColor.primary()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Settings"
        
        // Add menu button
        let menuImage = UIImage(named: "ic_menu")
        let menuButton = UIBarButtonItem(image: menuImage, style: .Plain, target: self, action: "menu:")
        navigationItem.leftBarButtonItem = menuButton
        
        // Create Form
        form +++ Section("")
            <<< ButtonRow("about") {
                $0.title = "About"
                $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return AboutViewController() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
            } <<< ButtonRow("editProfile") {
                $0.title = "Edit Profile"
                $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return EditProfileViewController() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
        }
        form +++ Section("")
            <<< ButtonRow("signOut") {
                $0.title = "Sign Out"
                }.cellSetup { cell, row in
                    cell.tintColor = STColor.primary()
                    cell.textLabel?.textAlignment = .Left
                }.onCellSelection { cell, row in
                    self.signOut(true)
        }
        
    }
    
    // MARK: Actions
    
    func menu(sender: UIBarButtonItem){
        
        // Present the side menu of the drawer view controller
        let drawerViewController: DrawerViewController = self.navigationController?.parentViewController as! DrawerViewController
        drawerViewController.setPaneState(.Open, animated: true, allowUserInterruption: true, completion: nil)
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