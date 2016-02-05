//
//  FriendsTableViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Firebase
class MyFriendsTableViewController : UITableViewController {
    
    // MARK: Instance Variables
    private var sections : [String] = ["Added Me", "My Friends"]
    private var friends: [[String]] = [[], []]
    private var friendshipChangedHandle : FirebaseHandle = UInt()
    private var friendshipAddedHandle : FirebaseHandle = UInt()
    private var friendshipRemovedHandle : FirebaseHandle = UInt()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Friends"
        
        // Change the appearance of the seperator
        tableView.separatorStyle = .None
        
        
        // Register the table view's cells
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    
        beginListening()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Remove the firebase handles
        Constants.ref.removeObserverWithHandle(friendshipAddedHandle)
        Constants.ref.removeObserverWithHandle(friendshipChangedHandle)
        Constants.ref.removeObserverWithHandle(friendshipRemovedHandle)
    }
    
    
    func beginListening(){
        
        // Clear the list of friends
        for (var i = 0; i < friends.count; i++) {
            friends[i].removeAll()
        }
        
        let uid = Constants.ref.authData!.uid
        let myFriendshipsRef = Constants.ref.childByAppendingPath("friendships/\(uid)")
        
        // Create listener and store handle
        friendshipAddedHandle = myFriendshipsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            // This determines what should happen based on the status
            if(status == FriendshipStatus.PendingSent.rawValue){
                return
            }else if(status == FriendshipStatus.PendingReceived.rawValue){
                self.friends[0].append(theirId)
            }else if(status == FriendshipStatus.Accepted.rawValue){
                self.friends[1].append(theirId)
            }
            
            self.tableView.reloadData()
        })
        
        // Create listener and store handle
        friendshipChangedHandle = myFriendshipsRef.observeEventType(.ChildChanged, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            // Remove the user from any array in friends
            for (var i = 0; i < self.friends.count; i++){
                self.friends[i] =  self.friends[i].filter({ $0 != theirId })
            }
            
            // This determines what should happen based on the status
            if(status == FriendshipStatus.PendingReceived.rawValue){
                self.friends[0].append(theirId)
            }else if(status == FriendshipStatus.Accepted.rawValue){
                self.friends[1].append(theirId)
            }
            
            self.tableView.reloadData()
        })
        
        // Create listener and store handle
        friendshipRemovedHandle = myFriendshipsRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let theirId = snapshot .key
            
            // Remove the user from any array in friends
            for (var i = 0; i < self.friends.count; i++){
                self.friends[i] =  self.friends[i].filter({ $0 != theirId })
            }
            self.tableView.reloadData()
        })
    }
    
    // Used to hash the index path so we can distinguish between cells
    func getTagFromIndexPath(indexPath: NSIndexPath) -> Int {
        return indexPath.row + 500 * indexPath.section
    }
    
    // Used to get a index path from a cell's tag
    func getIndexPathFromTag(tag: Int) -> NSIndexPath {
        let row = tag % 500
        let section = tag / 500
        return NSIndexPath(forRow: row, inSection: section)
    }
    
    // MARK: Selectors
    
    func acceptFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        // Identify each users friendship reference
        let myId = Constants.ref.authData!.uid
        let theirId = friends[indexPath.section][indexPath.row]
        let myFriendshipsRef = Constants.ref.childByAppendingPath("friendships/\(myId)")
        let theirFriendshipsRef = Constants.ref.childByAppendingPath("friendships/\(theirId)")
        
        // Set the status to rejected
        myFriendshipsRef.childByAppendingPath(theirId).setValue(FriendshipStatus.Accepted.rawValue)
        theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.Accepted.rawValue)
    }
    
    func rejectFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        // Identify each users friendship reference
        let myId = Constants.ref.authData!.uid
        let theirId = friends[indexPath.section][indexPath.row]
        let myFriendshipsRef = Constants.ref.childByAppendingPath("friendships/\(myId)")
        let theirFriendshipsRef = Constants.ref.childByAppendingPath("friendships/\(theirId)")
        
        // Set the status to rejected
        myFriendshipsRef.childByAppendingPath(theirId).setValue(FriendshipStatus.Rejected.rawValue)
        theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.Rejected.rawValue)
    }
    
    // MARK: TableViewDatasource
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return friends.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (friends[section].count > 0) ? 30 : 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends[section].count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.userCellHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = friends[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.setUser(user)
        
        // Changes what kind of cell should be displayed
        if(indexPath.section == 0){
            cell.setType(.PendingReceived)
        }else if(indexPath.section == 1){
            cell.setType(.Accepted)
        }
        
        cell.acceptButton.tag = getTagFromIndexPath(indexPath)
        cell.acceptButton.addTarget(self, action: "acceptFriendship:", forControlEvents: .TouchUpInside)
        cell.rejectButton.tag = getTagFromIndexPath(indexPath)
        cell.rejectButton.addTarget(self, action: "rejectFriendship:", forControlEvents: .TouchUpInside)
    
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Display a popup with information about the selected user
        let user = friends[indexPath.section][indexPath.row]
        let alertController = UIAlertController(title: user, message:
            "Here it will display a popup with information about the selected user", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}