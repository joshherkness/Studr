//
//  DrawerViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import MMDrawerController

class DrawerViewController: MMDrawerController {
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNavigationController:UINavigationController = UINavigationController(rootViewController: centerViewController)
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SideViewController") as! SideViewController
        
        self.centerViewController = centerNavigationController
        self.leftDrawerViewController = leftViewController
        
        self.openDrawerGestureModeMask = MMOpenDrawerGestureMode.All
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
        self.setDrawerVisualStateBlock(MMDrawerVisualState.slideVisualStateBlock())
        self.shouldStretchDrawer = true
        self.showsShadow = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
