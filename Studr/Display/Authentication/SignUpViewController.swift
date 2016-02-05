//
//  SignUpViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 10/31/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Firebase
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

        let username = usernameField.text!
        let password = passwordField.text!
        let email = emailField.text!
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        
        // TODO: Check for errors with the users input
        
        //Create the user
        Constants.ref.createUser(email, password: password,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    // There was an error creating the account
                    print(error)
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    
                    // Now we save the users information to the database under the uid
                    let usersRef = Constants.ref.childByAppendingPath("users").childByAppendingPath(uid)
                    let user = ["username": username, "first_name": firstName, "last_name": lastName, "email": email]
                    usersRef.setValue(user)
                    
                    Constants.ref.authUser(email, password: password) { (error, data) -> Void in
                        if(error == nil){
                            
                            // Launch user into main application
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            let mainTabBarController = MainTabBarController()
                            self.presentViewController(mainTabBarController, animated: true, completion: {
                                appDelegate.window?.rootViewController = mainTabBarController
                            })
                            
                        }else{
                            print(error.description)
                            let alertController = UIAlertController(title: "Authentication Error", message:
                                error.description, preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                }
        })
    
    }
}