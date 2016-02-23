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
    
    public var row: RowOf<Set<User>>!
    public var completionCallback : ((UIViewController) -> ())?
    private var members: [User] = []
    private var perspectiveMembers: [User] = []
    
    private var myFriendshipsRef: Firebase?
    private var friendshipAddedHandle: FirebaseHandle?
    private var friendshipChangedHandle: FirebaseHandle?
    private var friendshipRemovedHandle: FirebaseHandle?
    
    // MARK: Initializers
    
    convenience public init(_ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the title
        navigationItem.title = "Friends"
        
        // Setup tableview
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: "UserCell")
        
        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        
        // Add done button
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.leftBarButtonItem = button
        
        // Load the existing selected users into the array
        members = Array(row.value!)
        
        // Firebase
        if let authData = Database.BASE_REF.authData {
            myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(authData.uid)
            myFriendshipsRef?.keepSynced(true)
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Begin listening to the database
        beginObserving()
    }
    public override func viewDidDisappear(animated: Bool) {
        myFriendshipsRef?.removeAuthEventObserverWithHandle(friendshipAddedHandle!)
        myFriendshipsRef?.removeAuthEventObserverWithHandle(friendshipChangedHandle!)
        myFriendshipsRef?.removeAuthEventObserverWithHandle(friendshipRemovedHandle!)
    }
    
    func beginObserving(){
        
        perspectiveMembers.removeAll()
    
        friendshipAddedHandle = myFriendshipsRef?.observeEventType(.ChildAdded, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            // This determines what should happen based on the status
            if(status == FriendshipStatus.Accepted.rawValue){
                Database.getUser(theirId, completion: { user in
                    self.perspectiveMembers.append(user)
                    self.tableView.reloadData()
                })
            }
        })
        
        friendshipChangedHandle = myFriendshipsRef?.observeEventType(.ChildChanged, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            Database.getUser(theirId, completion: { user in
                if(status == FriendshipStatus.Accepted.rawValue && !self.perspectiveMembers.contains(user)){
                    self.tableView.reloadData()
                }
            })
        })
        
        friendshipRemovedHandle = myFriendshipsRef?.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let theirId = snapshot .key
            
            // Remove the user from any array in friends
            self.perspectiveMembers = self.perspectiveMembers.filter({ $0.uid != theirId })
            
            self.tableView.reloadData()
        })
    }
    
    func tappedDone(sender: UIButton){
    
        // Add each member to a set
        var membersSet = Set<User>()
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UserCell
        cell?.accessoryType = .Checkmark
        members.append(perspectiveMembers[indexPath.row])
    }
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UserCell
        cell?.accessoryType = .None
        members = members.filter({ $0.uid != perspectiveMembers[indexPath.row].uid })
    }
    
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.userCellHeight
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perspectiveMembers.count
    }
    
    //MARK: UITableViewDataSource
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = perspectiveMembers[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.configureCell(user)
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
