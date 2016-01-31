//
//  MyGroupsViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 1/25/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import UIKit

class MyGroupsViewController: UIViewController {
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view controllers background color
        view.backgroundColor = UIColor.whiteColor()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "My Groups"
    }
}