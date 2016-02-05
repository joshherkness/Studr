//
//  MyGroupsViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 1/25/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import UIKit

class MyGroupsViewController: UIViewController {
    
    // MARK: Instance Variables
    
    private var createButton: UIBarButtonItem = UIBarButtonItem()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view controllers background color
        view.backgroundColor = UIColor.whiteColor()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Groups"
        
        // Add create button
        createButton = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "create")
        navigationItem.setRightBarButtonItem(createButton, animated: false)
    }
    
    func create(){
        let createGroupNavigationController = UINavigationController(rootViewController: CreateGroupViewController())
        presentViewController(createGroupNavigationController, animated: true, completion: nil)
    }
}