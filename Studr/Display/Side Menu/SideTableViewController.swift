//
//  SideTableViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework
import MMDrawerController

class SideTableViewController: UITableViewController{
    
    var data: [[MenuItem]] = []
    
    // MARK: UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "SideTableViewCell", bundle: nil), forCellReuseIdentifier: "SideTableViewCell")
        
        // Create menu items
        addMenuItem("My Groups", iconName: "ic_event", color: UIColor(hexString: "#56D289"), selector: "showGroupsViewController", section: 0)
        addMenuItem("Scan QR", iconName: "ic_qrcode", color: FlatYellow(), selector: nil, section: 0)
        addMenuItem("Friends", iconName: "ic_group", color: FlatMagenta(), selector: "showFriendsViewController", section: 0)
        addMenuItem("Settings", iconName: "ic_settings", color: FlatSkyBlue(), selector: "showSettingsViewController", section: 0)
        
        // Hide all empty table view cells
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = UIColor(hexString: "302F32")
        tableView.separatorColor = view.backgroundColor?.lightenByPercentage(0.05)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.autoresizingMask = .FlexibleWidth
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let menuItem: MenuItem = data[section][row]
        
        // Perform some action
        performSelector(menuItem.selector)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 64
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0) {
            return 0
        }
        
        return 30
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor(hexString: "121212")
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    //MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideTableViewCell", forIndexPath: indexPath) as! SideTableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    // MARK: Methods
    
    func configureCell(cell: SideTableViewCell, forRowAtIndexPath: NSIndexPath) {
        
        let section = forRowAtIndexPath.section
        let row = forRowAtIndexPath.row
        
        let menuItem: MenuItem = data[section][row]
        
        // Update the attributes of the cell
        cell.tagLabel?.text = menuItem.title
        cell.iconView?.image = UIImage(named: menuItem.iconName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.iconView?.tintColor = menuItem.color
        
        // Create the selected background color
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = cell.backgroundColor?.darkenByPercentage(0.10)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Disable the cell if no selector is specified
        if (menuItem.selector == nil) {
            cell.userInteractionEnabled = false
        }

    }
    
    func showCreateGroupViewController(){
        moveToViewController(CreateGroupViewController())
    }
    
    func showGroupsViewController(){
        moveToViewController(GroupsViewController())
    }
    
    func showFriendsViewController(){
        moveToViewController(FriendsTableViewController())
    }
    
    func showSettingsViewController(){
        
        // Create the new settings view controller
        let settingsViewController: UIViewController = SettingsViewController()
        let settingsNavigationController:UINavigationController = UINavigationController(rootViewController: settingsViewController)
        
        // Determine wether a drawer controller should close
        if let drawerController = self.mm_drawerController {
            // Close the drawer controller
            drawerController.closeDrawerAnimated(true, completion: { (bool) -> Void in
                drawerController.centerViewController.presentViewController(settingsNavigationController, animated: true, completion: nil)
            })
        } else {
            self.presentViewController(settingsNavigationController, animated: true, completion: nil)
        }
    }
    
    func moveToViewController(viewController: UIViewController) {
        
        // Set the center panel to the new event view controller
        if let drawerController = self.mm_drawerController {
            // Center view controller as navigation controller
            drawerController.setCenterViewController(UINavigationController(rootViewController: viewController), withCloseAnimation: true, completion: nil)
        } else {
            // Create the drawer controller, and present it
            let drawerController = MMDrawerController(centerViewController: viewController, leftDrawerViewController: SideTableViewController())
            presentViewController(drawerController, animated: false, completion: nil)
        }
    }
    
    func addMenuItem(title: String, iconName: String, color: UIColor, selector: Selector, section: Int){
        while(section >= data.count ){
            data.append([])
        }
        data[section].append(MenuItem(title: title, iconName: iconName, color: color, selector: selector))
    }
}

struct MenuItem {
    
    var title: String
    var color: UIColor
    var iconName: String
    var selector: Selector
    
    init(title: String, iconName: String, color: UIColor, selector: Selector){
        
        self.title = title
        self.iconName = iconName
        self.color = color
        self.selector = selector
    }
}









