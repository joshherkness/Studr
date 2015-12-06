//
//  EditProfileViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Parse

class EditProfileViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = Constants.Color.secondary
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Edit Profile"
        
        // Add back button
        let image = UIImage(named: "ic_chevron_left")
        let button = UIBarButtonItem(image: image, style: .Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = button
        
        // Create Form
        form +++ Section("Name")
            <<< NameRow() {
                $0.placeholder = "First"
                $0.value = PFUser.currentUser()!["firstName"] as? String
            }
            <<< NameRow() {
                $0.placeholder = "Last"
                $0.value = PFUser.currentUser()!["lastName"] as? String
        }
    }
    
    // MARK: Actions
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}