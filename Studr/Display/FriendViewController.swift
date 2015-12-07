
//
//  FriendsViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 12/6/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit

class FriendViewController : UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = Constants.Color.secondary
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.hidesNavigationBarHairline = true;
        self.title = "Friends"
        
        // Create an array to keep track of the controllers in the page menu
        var controllerArray : [UIViewController] = []
        
        // Initialize the view controllers and add them to the controller array
        let controller: UIViewController = FriendsTableViewController()
        controller.title = "My Friends"
        controllerArray.append(controller)
        
        let controller3: UIViewController = UIViewController()
        controller3.title = "Find Friends"
        controllerArray.append(controller3)
        
        // Customize the page menu
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(Constants.Color.secondary.darkenByPercentage(0.04)),
            .ViewBackgroundColor(Constants.Color.secondary.darkenByPercentage(0.04)),
            .UnselectedMenuItemLabelColor(UIColor.whiteColor().colorWithAlphaComponent(0.2)),
            .MenuItemSeparatorWidth(0),
            .UseMenuLikeSegmentedControl(true),
            .AddBottomMenuHairline(false),
            .ScrollAnimationDurationOnMenuItemTap(200),
            .MenuHeight(40),
            .EnableHorizontalBounce(false),
            .SelectionIndicatorHeight(0)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // Add the page menu as a subview of the base view controller's view
        self.view.addSubview(pageMenu!.view)
    }

}