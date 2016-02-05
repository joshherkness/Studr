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

class EditProfileViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Edit Profile"
        
        // Add back button
        let image = UIImage(named: "ic_chevron_left")
        let button = UIBarButtonItem(image: image, style: .Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = button
    }
    
    // MARK: Actions
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}