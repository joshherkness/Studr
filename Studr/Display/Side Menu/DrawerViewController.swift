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
        
    }
    
    /**
     Method used to create view controller in storyboard
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        addStylersFromArray([MSDynamicsDrawerParallaxStyler.styler()], forDirection: MSDynamicsDrawerDirection.Left)
        
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GroupsViewController") as! GroupsViewController
        let centerNavigationController:UINavigationController = UINavigationController(rootViewController: centerViewController)
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SideTableViewController") as! SideTableViewController
        
        setPaneViewController(centerNavigationController, animated: false, completion: nil)
        setDrawerViewController(leftViewController, forDirection: .Left)
        
        setup()
        
    }
    
    func setup(){
        
        gravityMagnitude = 6.0
        elasticity = 0.0
        bounceElasticity = 0.0
        bounceMagnitude = 0.0
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    

    
}
