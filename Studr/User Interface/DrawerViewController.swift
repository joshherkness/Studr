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
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        addStylersFromArray([MSDynamicsDrawerParallaxStyler.styler()], forDirection: MSDynamicsDrawerDirection.Left)
        
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNavigationController:UINavigationController = UINavigationController(rootViewController: centerViewController)
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SideTableViewController") as! SideTableViewController
        
        setPaneViewController(centerNavigationController, animated: false, completion: nil)
        setDrawerViewController(leftViewController, forDirection: .Left)
        gravityMagnitude = 6.0
        elasticity = 0.0
        bounceElasticity = 0.0
        bounceMagnitude = 0.0
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
