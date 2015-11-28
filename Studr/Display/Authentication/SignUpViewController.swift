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

class SignUpViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var firstNameField: TextField!
    @IBOutlet weak var lastNameField: TextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColor(hexString: "63d297"))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Navigation bar color
        self.navigationController?.navigationBar.barTintColor = STColor.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.titleTextAttributes =
        
        // Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.userInteractionEnabled = false
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        
        // Update the status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                    
                    let drawerViewController: UIViewController = DrawerViewController()
                    
                    self.presentViewController(drawerViewController, animated: true, completion: {
                        appDelegate.window?.rootViewController = drawerViewController
                    })
                    
                }
            })
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let field = textField as! TextField
        field.layer.borderColor = field.borderColorFocused.CGColor
        field.textColor = field.textColorFocused
        field.backgroundColor = field.backgroundColorFocused.colorWithAlphaComponent(field.backgroundAlphaFocused)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let field = textField as! TextField
        field.layer.borderColor = field.borderColorUnFocused.CGColor
        field.textColor = field.textColorUnFocused
        field.backgroundColor = field.backgroundColorUnFocused
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}