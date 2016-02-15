//
//  AddMembersTableViewController.swift
//  Studr
//
//  Created by Robin Onsay on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Eureka

public class AddMembersTableViewController: UITableViewController, TypedRowControllerType {
    
    // MARK: Instance Variables
    public var row: RowOf<Set<String>>!
    public var completionCallback : ((UIViewController) -> ())?
    private var members: [String] = []
    private var perspectiveMembers: [String] = []
    
    private var friendshipAddedHandle: FirebaseHandle = FirebaseHandle()
    private var friendshipChangedHandle: FirebaseHandle = FirebaseHandle()
    private var friendshipRemovedHandle: FirebaseHandle = FirebaseHandle()
    
    convenience public init(_ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        // Allows selection of multiple cells in tableview
        tableView.allowsMultipleSelection = true
        
        // Remove the hairline between the cells
        tableView.separatorStyle = .None
        
        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        
        // Add done button
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.leftBarButtonItem = button
        
        // Load the existing selected users into the array
        members = Array(row.value!)
        
        // Begin listening to the database
        beginListening()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        Database.BASE_REF.removeAuthEventObserverWithHandle(friendshipAddedHandle)
        Database.BASE_REF.removeAuthEventObserverWithHandle(friendshipChangedHandle)
        Database.BASE_REF.removeAuthEventObserverWithHandle(friendshipRemovedHandle)
    }
    
    func beginListening(){
        
        // Clear the list of perspective members
        perspectiveMembers.removeAll()
        
        let myId = Database.BASE_REF.authData!.uid
        let myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(myId)
        
        // Create listener and store handle
        friendshipAddedHandle = myFriendshipsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            // This determines what should happen based on the status
            if(status == FriendshipStatus.Accepted.rawValue){
                self.perspectiveMembers.append(theirId)
            }
            
            self.tableView.reloadData()
        })
        
        // Create listener and store handle
        friendshipChangedHandle = myFriendshipsRef.observeEventType(.ChildChanged, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            // This determines what should happen based on the status
            if(status == FriendshipStatus.Accepted.rawValue && !self.perspectiveMembers.contains(theirId)){
                self.perspectiveMembers.append(theirId)
            }
            
            self.tableView.reloadData()
        })
        
        // Create listener and store handle
        friendshipRemovedHandle = myFriendshipsRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let theirId = snapshot .key
            
            // Remove the user from any array in friends
            self.perspectiveMembers = self.perspectiveMembers.filter({ $0 != theirId })
            
            self.tableView.reloadData()
        })
    }
    
    func tappedDone(sender: UIButton){
        
        // Add each member to a set
        var membersSet = Set<String>()
        for member in members {
            membersSet.insert(member)
        }
        
        // Set the row's value to the members set
        row.value = membersSet
        
        // Return to the previous view controller
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: UITableViewDelegate
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // To be called when a cell is seclected
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UserCell
        cell?.accessoryType = .Checkmark
        members.append(perspectiveMembers[indexPath.row])
    }
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UserCell
        cell?.accessoryType = .None
        members = self.perspectiveMembers.filter({ $0 != perspectiveMembers[indexPath.row] })
    }
    
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.userCellHeight
    }
    
    public override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForHeaderInSection: section)
    }
    
    public override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForFooterInSection: section)
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perspectiveMembers.count
    }
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: UITableViewDataSource
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = perspectiveMembers[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.setUser(user)
        cell.setType(.None)
        
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = Constants.Color.primary.colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Selects the cell if the data is being loaded for the first time
        if(members.contains(user)){
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        }
        cell.accessoryType = cell.selected ? .Checkmark : .None
        
        return cell
    }
}
