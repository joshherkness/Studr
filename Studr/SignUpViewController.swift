//
//  SignUpViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 10/31/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController : UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Activity Indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        
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
            
            let alertViewController = UIAlertController(title: "Invalid", message: "Username must be greater than 4 and password must be greater than 5", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default){ (action) in
                // ...
            }
            alertViewController.addAction(OKAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            
        } else if (email.utf16.count < 8) {
            
            let alertViewController = UIAlertController(title: "Invalid", message: "Please enter a valid emal", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default){ (action) in
                // ...
            }
            alertViewController.addAction(OKAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            
        } else {
            
            self.activityIndicator.startAnimating()
            
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                
                if ((error) != nil) {
                    
                    // Error notificaiton
                    let alertViewController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default){ (action) in
                        // ...
                    }
                    alertViewController.addAction(OKAction)
                    self.presentViewController(alertViewController, animated: true, completion: nil)
                    
                } else {
                    
                    // Launch user into main application
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let mainViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("main")
                    
                    self.presentViewController(mainViewController, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}