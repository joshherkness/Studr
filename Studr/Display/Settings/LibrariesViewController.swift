//
//  LibrariesViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Parse

class LibrarriesViewController: FormViewController {
    
    // MARK: Instance Variables
    
    var libraries = ["Parse", "Eureka", "Heneke", "Crypto Swift", "Chameleon Framework", "CAPSPageMenu"]
    
    // MARK: UIViewController
    
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
        
        // Add library rows to form
        let section = Section("Special thanks to")
        for l in libraries {
            let r = LabelRow()
            r.title = l
            section.append(r)
        }
        form.append(section)
    }
    
    // MARK: Actions
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
