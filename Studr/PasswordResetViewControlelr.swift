//
//  PasswordResetViewControlelr.swift
//  Studr
//
//  Created by Joshua Herkness on 11/1/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Mark: Actions
    
    @IBAction func requestNewPasswordAction(sender: AnyObject) {
        
        var email = self.emailField.text!
        
        if email.utf16.count < 8 {
            
            let alertViewController = UIAlertController(title: "Invalid", message: "Enter a valid email", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default){ (action) in
                // ...
            }
            alertViewController.addAction(OKAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            
        } else {
            
            email = email.lowercaseString
            email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            self.activityIndicator.startAnimating()
            
            PFUser.requestPasswordResetForEmailInBackground(email) { (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                
                if (error == nil) {
                    
                    let alertViewController = UIAlertController(title: "Success", message: "Success! Check your email!", preferredStyle: .Alert)
                    let OKButton = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                        // On OK action
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertViewController.addAction(OKButton)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alertViewController, animated: false, completion: nil)
                    })
                    
                } else {
                    
                    // Error notificaiton
                    let alertViewController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default){ (action) in
                        // ...
                    }
                    alertViewController.addAction(OKAction)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alertViewController, animated: false, completion: nil)
                    })
                    
                }
            }
            
        }
        
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
