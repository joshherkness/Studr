//
//  GroupViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 2/15/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class GroupViewController: FormViewController {
    
    // MARK: Instance Variables
    
    private var group: Group!
    
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
        
        // Change the background color
        view.backgroundColor = Color.lightGreyBackground
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationItem.title = group!.name
        
        // Create the form
        form +++ Section("")
            <<< ButtonRow("selectTime") {
                $0.title = "Select Time"
                $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return VotingViewController(group: self.group!) }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
        }
        
    }

}