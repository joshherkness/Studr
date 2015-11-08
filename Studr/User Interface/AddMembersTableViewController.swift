//
//  AddMembersTableViewController.swift
//  Studr
//
//  Created by Robin Onsay on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Foundation
import Parse
import XLForm

class AddMembersTableViewController: UITableViewController, XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController {
    
    var rowDescriptor : XLFormRowDescriptor?
    var popoverController : UIPopoverController?
    
    var userFriends = [PFObject]()
    var selectedFriends = [PFObject]()
    
    // Current cell
    var cell : UITableViewCell?
    
    // Array of selected cells ( Index Path )
    var selectedCells = [NSIndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Allows selection of multiple cells in tableview
        self.tableView.allowsMultipleSelection = true
        
        // Reload the data of the table
        reloadTableData()
        
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // To be called when a cell is seclected
        selectedFriends.append(userFriends[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForHeaderInSection: section)
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForFooterInSection: section)
    }
    
    //MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFriends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddMenuTableViewCell", forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        // Method to be called in configuring the cell, e.g setting the data atributes of the cell
        
        //var section = forRowAtIndexPath.section
        let row = forRowAtIndexPath.row
        
        let friend: PFObject = userFriends[row]
        
        //friend.objectForKey("profileImage") as? String
        cell.textLabel?.text = friend.objectForKey("userName") as? String
        
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Determine if the friend should be selected
        cell.selected = selectedFriends.contains(friend)
        
        cell.accessoryType = cell.selected ? .Checkmark : .None
        
    }
    
    private func reloadTableData() {
        // Fetch friend list from database, and store it in global variable friends
    }
}
