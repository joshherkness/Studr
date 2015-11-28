//
//  GroupsViewController.swift
//  Studr
//
//  Created by Robin Onsay on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//
import Foundation
import UIKit
import XLForm

class GroupsViewController : XLFormViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = STColor.green()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        
        // Add menu button
        let menuImage = UIImage(named: "ic_menu")
        let menuButton = UIBarButtonItem(image: menuImage, style: .Plain, target: self, action: "menu:")
        navigationItem.leftBarButtonItem = menuButton
        
        // Add create button
        let createImage = UIImage(named: "ic_add")
        let createButton = UIBarButtonItem(image: createImage, style: .Plain, target: self, action: "create:")
        navigationItem.rightBarButtonItem = createButton
    }
    
    func create(sender: UIBarButtonItem){
        
        // Make the create event view controller
        let createGroupViewController: UIViewController = CreateGroupViewController()
        let createGroupNavigationController:UINavigationController = UINavigationController(rootViewController: createGroupViewController)
        
        // Present the create event view controller
        self.presentViewController(createGroupNavigationController, animated: true, completion: nil)
    }
    
    func menu(sender: UIBarButtonItem){
        
        // Present the side menu of the drawer view controller
        let drawerViewController: DrawerViewController = self.navigationController?.parentViewController as! DrawerViewController
        drawerViewController.setPaneState(.Open, animated: true, allowUserInterruption: true, completion: nil)
    }

}
