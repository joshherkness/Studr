//
//  SideMenuViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 12/4/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var showsStatusBarBackgroundView: Bool? {
        didSet {
            if let showsStatusBarBackgroundView = showsStatusBarBackgroundView {
                if showsStatusBarBackgroundView {
                    tableView.frame.origin.y = 20
                    tableView.frame.size.height = view.frame.height - 20
                    statusBarView.hidden = false
                } else {
                    tableView.frame.origin.y = 0
                    tableView.frame.size.height = view.frame.height
                    statusBarView.hidden = true
                }
            }
        }
    }
    
    var statusBarViewBackgroundColor: UIColor! {
        didSet {
            statusBarView.backgroundColor = statusBarViewBackgroundColor
        }
    }
    
    private var statusBarView: UIView = UIView()
    
    private var tableView: UITableView = UITableView()
    
    private var data: [SideMenuItem] = []
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
        view.addSubview(statusBarView)
        
        // Modify apearence of view
        view.backgroundColor = Constants.Color.primary
        view.autoresizingMask = .FlexibleWidth
        
        // Table view properties
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView() // Hide all empty table view cells
        self.view.addSubview(tableView)
        
        // Register cell for table view
        tableView.registerNib(UINib(nibName: "SideTableViewCell", bundle: nil), forCellReuseIdentifier: "SideTableViewCell")
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        
        showsStatusBarBackgroundView = true
        statusBarViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        // Add navigation cells to table view
        data.append(SideMenuItem(text: "Groups",
            icon: UIImage(named: "ic_event"),
            destinationViewControllerType: GroupsViewController.self))
        data.append(SideMenuItem(text: "Friends",
            icon: UIImage(named: "ic_group"),
            destinationViewControllerType: FriendsTableViewController.self))
        data.append(SideMenuItem(text: "Settings",
            icon: UIImage(named: "ic_settings"),
            destinationViewControllerType: SettingsViewController.self))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sideMenuItem = data[indexPath.row]
        if let destinationViewControllerType = sideMenuItem.destinationViewControllerType {
            moveToViewController(destinationViewControllerType.init())
        }
        
        // Deselect row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
             let view = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell") as! FriendTableViewCell
            
            if let user = PFUser.currentUser() {
                view.setUser(user)
            }
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            return view
        }
        return nil
    }
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideTableViewCell", forIndexPath: indexPath) as! SideTableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    // MARK: Functions
    
    private func configureCell(cell: SideTableViewCell, forRowAtIndexPath: NSIndexPath) {
        
        let row = forRowAtIndexPath.row
        
        let sideMenuItem: SideMenuItem = data[row]
        
        // Update the attributes of the cell
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        if let tagLabel = cell.tagLabel {
            tagLabel.text = sideMenuItem.text
            tagLabel.textColor = UIColor.whiteColor()
        }
        
        if let iconView = cell.iconView {
            if let icon = sideMenuItem.icon {
                iconView.image = icon.imageWithRenderingMode(.AlwaysTemplate)
            }
            iconView.tintColor = UIColor.whiteColor()
        }
        
        // Create the selected background color
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = view.backgroundColor?.darkenByPercentage(0.05)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Disable the cell if no selector is specified
        if let _ = sideMenuItem.destinationViewControllerType {
            cell.userInteractionEnabled = true
        } else {
            cell.userInteractionEnabled = false
        }
    }
    
    private func moveToViewController(viewController: UIViewController) {
        
        // Set the center panel to the new event view controller
        if let drawerController = self.mm_drawerController {
            // Center view controller as navigation controller
            drawerController.setCenterViewController(UINavigationController(rootViewController: viewController), withCloseAnimation: true, completion: nil)
        }
    }
}

/**
 *  Structure used to describe a side menu item.
 */
internal struct SideMenuItem {
    
    var text: String
    var icon: UIImage?
    var destinationViewControllerType: UIViewController.Type?
    
    init(text: String, icon: UIImage?, destinationViewControllerType: UIViewController.Type?){
        
        self.text = text
        self.icon = icon
        self.destinationViewControllerType = destinationViewControllerType
    }
}












