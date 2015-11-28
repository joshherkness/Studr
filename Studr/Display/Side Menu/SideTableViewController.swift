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

class SideTableViewController: UITableViewController{
    
    var data: [[MenuItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "SideTableViewCell", bundle: nil), forCellReuseIdentifier: "SideTableViewCell")
        
        // Create menu items
        addMenuItem("My Groups", iconName: "ic_event", color: UIColor(hexString: "#56D289"), selector: "showGroupsViewController", section: 0)
        addMenuItem("Scan QR", iconName: "ic_qrcode", color: FlatYellow(), selector: nil, section: 0)
        addMenuItem("Friends", iconName: "ic_group", color: FlatMagenta(), selector: nil, section: 0)
        addMenuItem("Profile", iconName: "ic_person", color: FlatSkyBlue(), selector: nil, section: 0)
        addMenuItem("Settings", iconName: "ic_settings", color: FlatSkyBlue(), selector: nil, section: 0)
        addMenuItem("About", iconName: "ic_info_outline", color: FlatSkyBlue(), selector: nil, section: 0)
        addMenuItem("Logout", iconName: "ic_clear", color: FlatRed(), selector: "logOut", section: 0)
        
        // Hide all empty table view cells
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = UIColor(hexString: "302F32")
        tableView.separatorColor = view.backgroundColor?.darkenByPercentage(0.05)
        
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
    
    
    /**
     Configures the apearence of a table view cell at a give index in the table
     
     - parameter cell:              <#cell description#>
     - parameter forRowAtIndexPath: <#forRowAtIndexPath description#>
     */
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
    
    func logOut(){
        
        PFUser.logOut()
        
        // Close the drawer
        let drawerViewController: DrawerViewController = self.view.window!.rootViewController as! DrawerViewController
        drawerViewController.setPaneState(.Closed, animated: true, allowUserInterruption: true, completion: nil)
        
        // Return user to login view
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let logInViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("OnboardingViewController")
        
        self.presentViewController(logInViewController, animated: true, completion: {
            appDelegate.window?.rootViewController = logInViewController
        })
    }
    
    func showCreateGroupViewController(){
        
        // Get the new event view controller
        let createGroupViewController: UIViewController = CreateGroupViewController()
        let createGroupNavigationController:UINavigationController = UINavigationController(rootViewController: createGroupViewController)
        
        // Set the navigation bars tint color
        createGroupNavigationController.navigationBar.tintColor = UIColor(hexString: "#56D289")
        
        // Set the center panel to the new event view controller
        let drawerViewController: DrawerViewController = self.parentViewController as! DrawerViewController
        drawerViewController.setPaneState(.Closed, animated: true, allowUserInterruption: false, completion: nil)
        drawerViewController.presentViewController(createGroupNavigationController, animated: true, completion: nil)
        
    }
    func showGroupsViewController(){
        
        // Get the new event view controller
        let groupsViewController: UIViewController = GroupsViewController()
        let groupsNavigationController:UINavigationController = UINavigationController(rootViewController: groupsViewController)
        
        // Set the center panel to the new event view controller
        let drawerViewController: DrawerViewController = self.parentViewController as! DrawerViewController
        let currentPaneNavigationController:UINavigationController = drawerViewController.paneViewController as! UINavigationController
        let currentPaneViewController = currentPaneNavigationController.viewControllers.first
        
        if currentPaneViewController!.isKindOfClass(GroupsViewController.self) {
            drawerViewController.setPaneState(.Closed, animated: true, allowUserInterruption: false, completion: nil)
        } else {
            drawerViewController.setPaneViewController(groupsNavigationController, animated: true, completion: nil)
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









