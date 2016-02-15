//
//  GroupViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 2/15/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit

class GroupViewController: UIViewController {
    
    // MARK: Instance Variables
    
    private var group: Group!
    private var backButton: UIBarButtonItem!
    
    // MARK: UIViewController
    
    init(group: Group){
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view controllers background color
        view.backgroundColor = Constants.Color.lightGreyBackground
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationItem.title = group.name
        
    }
    
    // MARK: Selectors
    
}