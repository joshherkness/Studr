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
    
    private var sections = ["Added Me", "My Friends"]
    private var friends: [[User]] = [[], []]
    private var friendshipChangedHandle = FirebaseHandle()
    private var friendshipAddedHandle = FirebaseHandle()
    private var friendshipRemovedHandle = FirebaseHandle()
    
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
        Database.BASE_REF.removeObserverWithHandle(friendshipAddedHandle)
        Database.BASE_REF.removeObserverWithHandle(friendshipChangedHandle)
        Database.BASE_REF.removeObserverWithHandle(friendshipRemovedHandle)
    }
    
    func beginListening(){
        
        // Clear the list of friends
        for (var i = 0; i < friends.count; i++) {
            friends[i].removeAll()
        }
        
        let uid = Database.BASE_REF.authData!.uid
        let myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(uid)
        
        // Create listener and store handle
        friendshipAddedHandle = myFriendshipsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            Database.userFromId(theirId) { user in
                
                // This determines what should happen based on the status
                if(status == FriendshipStatus.PendingSent.rawValue){
                    return
                }else if(status == FriendshipStatus.PendingReceived.rawValue){
                    self.friends[0].append(user)
                }else if(status == FriendshipStatus.Accepted.rawValue){
                    self.friends[1].append(user)
                }
                
                self.tableView.reloadData()
                self.sortFriends()
            }
        })
        
        // Create listener and store handle
        friendshipChangedHandle = myFriendshipsRef.observeEventType(.ChildChanged, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
        
            Database.userFromId(theirId) { user in
                // Remove the user from any array in friends
                for (var i = 0; i < self.friends.count; i++){
                    self.friends[i] =  self.friends[i].filter({ $0.key != user.key })
                }
                
                // This determines what should happen based on the status
                if(status == FriendshipStatus.PendingReceived.rawValue){
                    self.friends[0].append(user)
                }else if(status == FriendshipStatus.Accepted.rawValue){
                    self.friends[1].append(user)
                }
            
                self.tableView.reloadData()
                self.sortFriends()
            }
        })
        
        // Create listener and store handle
        friendshipRemovedHandle = myFriendshipsRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let theirId = snapshot.key
            
            Database.userFromId(theirId) { user in
                
                // Remove the user from any array in friends
                for (var i = 0; i < self.friends.count; i++){
                    self.friends[i] =  self.friends[i].filter({ $0.key != user.key })
                }
                self.tableView.reloadData()
                self.sortFriends()
            }
        })
    }
    
    func sortFriends(){
        
        // Sort each array of friends based on their last name
        for (var i = 0; i < friends.count; i++) {
            friends[i].sortInPlace( { $0.lastname < $1.lastname })
        }
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
        let myId = Database.BASE_REF.authData!.uid
        let theirId = friends[indexPath.section][indexPath.row].key
        let myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(myId)
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
        // Set the status to rejected
        myFriendshipsRef.childByAppendingPath(theirId).setValue(FriendshipStatus.Accepted.rawValue)
        theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.Accepted.rawValue)
    }
    
    func rejectFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        // Identify each users friendship reference
        let myId = Database.BASE_REF.authData!.uid
        let theirId = friends[indexPath.section][indexPath.row].key
        let myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(myId)
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
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
        cell.configureCell(user)
        
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
        let alertController = UIAlertController(title: user.username, message:
            "Here it will display a popup with information about the selected user", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}