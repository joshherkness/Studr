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

class SignUpViewController : UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallScaleMultiple, color: UIColorFromHex(0x63d297))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.userInteractionEnabled = false
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
        
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
                    
                    // Launch user into main application
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let mainViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController")
                    
                    self.presentViewController(mainViewController, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}