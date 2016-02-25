//
//  SignInViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 10/31/15.
//  Copyright (c) 2015 Joshua Herkness. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ChameleonFramework

class SignInViewController : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInBtn: RoundedButton!
    
    // MARK: Instance Variables
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColor(hexString: "63d297"))
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Sign In"
        
        // Change colors
        emailField.tintColor = Color.primary
        passwordField.tintColor = Color.primary
        signInBtn.backgroundColor = Color.primary
        
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
        
        let email = emailField.text!
        let password = passwordField.text!
        
        Database.BASE_REF.authUser(email, password: password) { (error, data) -> Void in
            if(error == nil){
                
                // Launch user into main application
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let mainTabBarController = MainTabBarController()
                self.presentViewController(mainTabBarController, animated: true, completion: {
                    appDelegate.window?.rootViewController = mainTabBarController
                })
                
            }else{
                print(error)
                print(error.description)
                let alertController = UIAlertController(title: "Authentication Error", message:
                    error.description, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func authenticateTestUser(sender: AnyObject) {
        
        let email = "test@gmail.com"
        let password = "password"
        
        Database.BASE_REF.authUser(email, password: password) { (error, data) -> Void in
            if(error == nil){
                
                // Launch user into main application
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let mainTabBarController = MainTabBarController()
                self.presentViewController(mainTabBarController, animated: true, completion: {
                    appDelegate.window?.rootViewController = mainTabBarController
                })
                
            }else{
                print(error)
                print(error.description)
                let alertController = UIAlertController(title: "Authentication Error", message:
                    error.description, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToSignIn(unwindSegue: UIStoryboardSegue) {
    }
    
}