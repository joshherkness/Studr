//
//  GroupsViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import MMDrawerController

class GroupsViewController : UIViewController{
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = STColor.green()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        
        if let _ = self.mm_drawerController {
            // Add menu button
            let image = UIImage(named: "ic_menu")
            let button = UIBarButtonItem(image: image, style: .Plain, target: self, action: "toggleSideMenu:")
            navigationItem.leftBarButtonItem = button
        } else {
            // Add dismiss button
            let image = UIImage(named: "ic_clear")
            let button = UIBarButtonItem(image: image, style: .Plain, target: self, action: "dismiss:")
            navigationItem.leftBarButtonItem = button
        }

        // Add create button
        let createImage = UIImage(named: "ic_add")
        let createButton = UIBarButtonItem(image: createImage, style: .Plain, target: self, action: "create:")
        navigationItem.rightBarButtonItem = createButton
        
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
    
    func toggleSideMenu(sender: UIBarButtonItem) {
        if let drawerController = self.mm_drawerController {
            drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
        }
    }
    
    func dismiss(sender: UIBarButtonItem){
        // Dismiss view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}