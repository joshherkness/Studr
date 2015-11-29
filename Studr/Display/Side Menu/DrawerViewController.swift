//
//  DrawerViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import MSDynamicsDrawerViewController

class DrawerViewController: MSDynamicsDrawerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStylersFromArray([MSDynamicsDrawerScaleStyler.styler() ], forDirection: MSDynamicsDrawerDirection.Left)
        
        let centerViewController = GroupsViewController()
        let centerNavigationController:UINavigationController = UINavigationController(rootViewController: centerViewController)
        let leftViewController = SideTableViewController()
        
        setPaneViewController(centerNavigationController, animated: false, completion: nil)
        setDrawerViewController(leftViewController, forDirection: .Left)
        setRevealWidth(200, forDirection: MSDynamicsDrawerDirection.Left)
        
        setup()
    }
    
    func setup(){
        
        gravityMagnitude = 6.0
        elasticity = 0.0
        bounceElasticity = 0.0
        bounceMagnitude = 0.0
        paneViewSlideOffAnimationEnabled = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}
