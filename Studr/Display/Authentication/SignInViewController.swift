//
//  SignInViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 10/31/15.
//  Copyright (c) 2015 Joshua Herkness. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import ChameleonFramework

class SignInViewController : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInBtn: RoundedButton!
    
    // MARK: Instance Variables
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColor(hexString: "63d297"))
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Sign In"
        
        // Change colors
        usernameField.tintColor = Constants.Color.primary
        passwordField.tintColor = Constants.Color.primary
        signInBtn.backgroundColor = Constants.Color.primary
        
        // Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.userInteractionEnabled = false  // Otherwise you cant touch behind the view
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /**
     Resigns the keyboard when the user touches the view
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // Mark: Actions

    @IBAction func signInAction(sender: AnyObject) {
        
        let username = self.usernameField.text!
        let password = self.passwordField.text!
        
        if username.utf16.count < 4 || password.utf16.count < 5 {
            
            // Invalid notification
            let invalidAlert = UIAlertController(title: "Invalid", message: "Username must be greater than 4 and password must be greater than 5", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            invalidAlert.addAction(OKAction)
            self.presentViewController(invalidAlert, animated: true, completion: nil)
    
        } else {
            
            // Begin activity indicator
            self.activityIndicator.startAnimation()
            
            // SignIn user
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                // Stop activity indicator
                self.activityIndicator.stopAnimation()
                
                if ((user) != nil) {
                    
                    // Launch user into main view controller as a navigation view controller
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    let mainTabBarController = MainTabBarController()
                    self.presentViewController(mainTabBarController, animated: true, completion: {
                        appDelegate.window?.rootViewController = mainTabBarController
                    })
                    
                } else {
                    
                    // Error notification
                    let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorAlert.addAction(OKAction)
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    @IBAction func authenticateTestUser(sender: AnyObject) {
        // Sign in user
        PFUser.logInWithUsernameInBackground("testUser", password: "password", block: { (user, error) -> Void in
            
            // Stop activity indicator
            self.activityIndicator.stopAnimation()
            
            if ((user) != nil) {
                
                // Launch user into main view controller as a navigation view controller
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let mainTabBarController = MainTabBarController()
                self.presentViewController(mainTabBarController, animated: true, completion: {
                    appDelegate.window?.rootViewController = mainTabBarController
                })
                
            }
        })

    }
    
    @IBAction func unwindToSignIn(unwindSegue: UIStoryboardSegue) {
    }
    
}