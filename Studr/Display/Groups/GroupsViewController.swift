//
//  GroupsViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit

class GroupsViewController : UIViewController{
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = Constants.Color.secondary
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // MARK: Actions

    func create(sender: UIBarButtonItem){

        // Make the create event view controller
        let createGroupViewController: UIViewController = CreateGroupViewController()
        let createGroupNavigationController:UINavigationController = UINavigationController(rootViewController: createGroupViewController)

        // Present the create event view controller
        self.presentViewController(createGroupNavigationController, animated: true, completion: nil)
    }
}