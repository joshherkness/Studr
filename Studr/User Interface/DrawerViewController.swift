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
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        self.addStylersFromArray([MSDynamicsDrawerParallaxStyler.styler(), MSDynamicsDrawerFadeStyler
            .styler()], forDirection: MSDynamicsDrawerDirection.Left)
        
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNavigationController:UINavigationController = UINavigationController(rootViewController: centerViewController)
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SideViewController") as! SideViewController
        
        self.setPaneViewController(centerNavigationController, animated: false, completion: nil)
        self.setDrawerViewController(leftViewController, forDirection: .Left)
        self.gravityMagnitude = 4
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
