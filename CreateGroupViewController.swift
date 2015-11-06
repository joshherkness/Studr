//
//  CreateGroupViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/5/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit

class CreateGroupViewController: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func sideMenuToggleAction(sender: AnyObject) {
        print("Hlelo")
        let drawerViewController: DrawerViewController = self.view.window!.rootViewController as! DrawerViewController
        drawerViewController.setPaneState(.Open, animated: true, allowUserInterruption: true, completion: nil)
        
    }
}