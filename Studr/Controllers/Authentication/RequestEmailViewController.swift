//
//  RequestEmailViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 2/4/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class RequestEmailViewController : FormViewController {
    
    // MARK: Instance Variables
    private var signInButton: UIBarButtonItem = UIBarButtonItem()
    private var email: String = ""
    private var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Studr"
        
        // Add navigation buttons
        signInButton = UIBarButtonItem(title: "Sign In", style: .Plain, target: self, action: "login")
        signInButton.enabled = false
        navigationItem.setRightBarButtonItem(signInButton, animated: false)
        
        // Default cell appearances
        EmailRow.defaultCellUpdate = {cell, row in
            cell.titleLabel?.textColor = UIColor(hexString: "8A919E")
        }
        PasswordRow.defaultCellUpdate = {cell, row in
            cell.titleLabel?.textColor = UIColor(hexString: "8A919E")
        }
        
        // Create the form
        form +++ Section("")
            <<< EmailRow("emailRow"){
                $0.title = "Email"
                $0.placeholder = "Type your email adress"
                
            }.onChange({ row in
                if let _ = row.value {
                    self.email = row.value! as String
                }else{
                    self.email = ""
                }
                self.validate()
            })
            <<< PasswordRow("passwordRow"){
                $0.title = "Password"
                $0.placeholder = "Type your password"
            }.onChange({row in
                if let _ = row.value {
                    self.password = row.value! as String
                }else{
                    self.password = ""
                }
                self.validate()
            })
    }

    // MARK: Authentication Methods
    
    func validate(){
        if(!email.isEmpty && email.containsString("@") && email.containsString(".") && !password.isEmpty){
            signInButton.enabled = true
        }else{
            signInButton.enabled = false
        }
    }
    
    func login(){
        Database.BASE_REF.authUser(email, password: password) { (error, data) -> Void in
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
    
}