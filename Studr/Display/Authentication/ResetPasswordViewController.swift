//
//  ResetPasswordViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/1/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import ChameleonFramework

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColor(hexString: "63d297"))
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Navigation bar color
        self.navigationController?.navigationBar.barTintColor = STColor.primary()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.userInteractionEnabled = false
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
        
        emailField.delegate = self
        
        setNeedsStatusBarAppearanceUpdate()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // Mark: Actions
    
    @IBAction func requestNewPasswordAction(sender: AnyObject) {
        
        var email = self.emailField.text!
        
        if email.utf16.count < 8 {
            
            // Invalid notification
            let invalidAlert = UIAlertController(title: "Invalid", message: "Please enter a valid email", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            invalidAlert.addAction(OKAction)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentViewController(invalidAlert, animated: true, completion: nil)
            })
            
        } else {
            
            // Transform email string
            email = email.lowercaseString
            email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            // Begin activity indicaor
            self.activityIndicator.startAnimation()
            
            PFUser.requestPasswordResetForEmailInBackground(email) { (success, error) -> Void in
                
                // End activity indicator
                self.activityIndicator.startAnimation()
                
                if (error == nil) {
                    
                    // Success notification
                    let successAlert = UIAlertController(title: "Success", message: "Check your email to change your password", preferredStyle: .Alert)
                    let OKButton = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    successAlert.addAction(OKButton)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(successAlert, animated: true, completion: nil)
                    })
                    
                } else {
                    
                    // Error notificaiton
                    let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorAlert.addAction(OKAction)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(errorAlert, animated: false, completion: nil)
                    })
                }
            }
        }
    }
}
