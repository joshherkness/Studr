//
//  SignUpViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 10/31/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import ChameleonFramework

class SignUpViewController : UIViewController{
    
    // MARK: Outlets
    
    @IBOutlet weak var firstNameField: TextField!
    @IBOutlet weak var lastNameField: TextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpBtn: RoundedButton!
    
    // MARK: Instance Variables
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColor(hexString: "63d297"))
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Sign Up"
        
        // Change interface element colors
        firstNameField.tintColor = Constants.Color.primary
        lastNameField.tintColor = Constants.Color.primary
        emailField.tintColor = Constants.Color.primary
        usernameField.tintColor = Constants.Color.primary
        passwordField.tintColor = Constants.Color.primary
        signUpBtn.backgroundColor = Constants.Color.primary
        
        // Create activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.userInteractionEnabled = false
        
        // Add the activity indicator
        view.addSubview(self.activityIndicator)
        
        // Update the status bar
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
    
    @IBAction func signUpAction(sender: AnyObject) {
        
        let username = self.usernameField.text!
        let password = self.passwordField.text!
        let email = self.emailField.text!
        
        if username.utf16.count < 4 || password.utf16.count < 5 {
            
            // Invalid noification
            let invalidAlert = UIAlertController(title: "Invalid", message: "Your username must be greater than 4, and your password greater than 5", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            invalidAlert.addAction(OKAction)
            self.presentViewController(invalidAlert, animated: true, completion: nil)
            
        } else if (email.utf16.count < 8) {
            
            // Invalid notification
            let invalidAlert = UIAlertController(title: "Invalid", message: "Please enter a valid email", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            invalidAlert.addAction(OKAction)
            self.presentViewController(invalidAlert, animated: true, completion: nil)
            
        } else {
            
            // Begin activity indicator
            self.activityIndicator.startAnimation()
            
            // Create a new parse user
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop activity indicator
                self.activityIndicator.stopAnimation()
                
                if ((error) != nil) {
                    
                    // Error notification
                    let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorAlert.addAction(OKAction)
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                    
                } else {
                    
                    // Launch user into main view controller as a navigation view controller
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    let mainTabBarController = MainTabBarController()
                    self.presentViewController(mainTabBarController, animated: true, completion: {
                        appDelegate.window?.rootViewController = mainTabBarController
                    })
                    
                }
            })
        }
    }
}