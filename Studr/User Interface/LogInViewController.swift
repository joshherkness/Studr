//
//  LogInViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 10/31/15.
//  Copyright (c) 2015 Joshua Herkness. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

class LogInViewController : UIViewController{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColorFromHex(0x63d297))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.userInteractionEnabled = false  // Otherwise you cant touch behind the view
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Mark: Actions

    @IBAction func loginAction(sender: AnyObject) {
        
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
            
            // Login user
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                // Stop activity indicator
                self.activityIndicator.stopAnimation()
                
                if ((user) != nil) {
                    
                    // Launch user into main view controller as a navigation view controller
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let viewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController")
                    let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
                    
                    self.presentViewController(navigationController, animated: true, completion: {
                        appDelegate.window?.rootViewController = navigationController
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
    
    @IBAction func signUpAction(sender: AnyObject) {
        self.performSegueWithIdentifier("SignUp", sender: self)
    }
    
    @IBAction func resetPasswordAction(sender: AnyObject) {
        self.performSegueWithIdentifier("PasswordReset", sender: self)
    }
    
}

// Generate UIColor from HEX value
func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}