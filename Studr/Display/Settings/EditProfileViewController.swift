//
//  EditProfileViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Parse

class EditProfileViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        
        // Add back button
        let image = UIImage(named: "ic_chevron_left")
        let button = UIBarButtonItem(image: image, style: .Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = button
        
        // Retrieve the profile information
        var username = PFUser.currentUser()!["username"] as? String
        var firstName = PFUser.currentUser()!["firstName"] as? String
        var lastName = PFUser.currentUser()!["lastName"] as? String
        
        // Create the form
        form +++ Section("Name")
            <<< NameRow() {
                $0.placeholder = "Username"
                $0.value = username
            }.onChange({ (row) -> () in username = username })
            <<< NameRow() {
                    $0.placeholder = "First"
                    $0.value = firstName
            }.onChange({ (row) -> () in firstName = firstName })
            <<< NameRow() {
                $0.placeholder = "Last"
                $0.value = lastName
            }.onChange({ (row) -> () in lastName = lastName })
        
        form +++ Section("")
            <<< ButtonRow("saveProfile") {
                $0.title = "Save Profile"
                }.cellSetup { cell, row in
                    cell.textLabel?.textAlignment = .Left
                }.onCellSelection { cell, row in
                    
                    PFUser.currentUser()?.setValue(username, forKey: "username")
                    PFUser.currentUser()?.setValue(firstName, forKey: "firstName")
                    PFUser.currentUser()?.setValue(lastName, forKey: "lastName")
                    
                    PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if(error == nil){
                            //Loading code goes here
                            print("saved")
                        }else{
                            print(error)
                        }
                    })
        }
    }
    
    // MARK: Actions
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}