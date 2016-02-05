
//
//  FriendViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 12/6/15.
//  Copyright © 2015 JJR. All rights reserved.
//
//  This View Controller serves as a container that holds various friend related
//  view controllers. It presents these view controllers using a page menu.
//

import Foundation
import UIKit

class FriendViewController : UIViewController, CAPSPageMenuDelegate {
    
    // MARK: Instance Variables
    
    var pageMenu : CAPSPageMenu?
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Friends"
        
        // Create an array to keep track of the controllers in the page menu
        var controllerArray : [UIViewController] = []
        
        // Initialize the view controllers and add them to the controller array
        let controller: UIViewController = MyFriendsTableViewController()
        controller.title = "My Friends"
        
        controllerArray.append(controller)
        
        let controller3: UIViewController = AddFriendsTableViewController()
        controller3.title = "Find Friends"
        controllerArray.append(controller3)
        
        // Customize the page menu
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(Constants.Color.primary),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .UnselectedMenuItemLabelColor(UIColor.whiteColor().colorWithAlphaComponent(0.5)),
            .MenuItemSeparatorWidth(0),
            .UseMenuLikeSegmentedControl(true),
            .AddBottomMenuHairline(false),
            .ScrollAnimationDurationOnMenuItemTap(200),
            .MenuHeight(40),
            .EnableHorizontalBounce(false),
            .SelectionIndicatorHeight(4),
            .SelectionIndicatorColor(Constants.Color.lightGrey)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        
        // Add the page menu as a subview of the base view controller's view
        self.view.addSubview(pageMenu!.view)
    }
    
}