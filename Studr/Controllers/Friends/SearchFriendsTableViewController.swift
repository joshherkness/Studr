//
//  SearchFriendsTableViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 2/18/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class SearchFriendsTableViewController : UITableViewController, UISearchResultsUpdating {
    
    // MARK: Instance Variables
    
    private var results: [User] = []
    private var myFriendshipsRef: Firebase?
    private var friendshipAddedHandle: FirebaseHandle!
    private var friendshipChangedHandle: FirebaseHandle!
    private var friendshipRemovedHandle: FirebaseHandle!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableview
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: "UserCell")
        
        // Firebase
        if let authData = Database.BASE_REF.authData {
            myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(authData.uid)
            myFriendshipsRef?.keepSynced(true)
        }
        
        beginObserving()
    }
    
    func beginObserving(){
    
        friendshipAddedHandle = myFriendshipsRef?.observeEventType(.ChildAdded, withBlock: { snapshot in
            self.tableView.reloadData()
        })
        
        friendshipChangedHandle = myFriendshipsRef?.observeEventType(.ChildChanged, withBlock: { snapshot in
            self.tableView.reloadData()
        })
        
        friendshipRemovedHandle = myFriendshipsRef?.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.tableView.reloadData()
        })
    }
    
    // MARK: TableViewDatasource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Config.userCellHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Determine the user that the cell should display
        let user = results[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.configureCell(user)
        
        // Determine the type of cell that should be displayed
        myFriendshipsRef?.childByAppendingPath(user.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let status = snapshot.value as? String
            if status != nil {
                switch status! {
                case FriendshipStatus.PendingReceived.rawValue: cell.setType(.PendingReceived); break
                case FriendshipStatus.PendingSent.rawValue: cell.setType(.PendingSent); break
                case FriendshipStatus.Accepted.rawValue: cell.setType(.Accepted); break
                default: cell.setType(.Send)
                }
            }else{
                cell.setType(.Send)
            }
        })
        
        cell.addButton.tag = getTagFromIndexPath(indexPath)
        cell.addButton.addTarget(self, action: "addFriendship:", forControlEvents: .TouchUpInside)
        cell.acceptButton.tag = getTagFromIndexPath(indexPath)
        cell.acceptButton.addTarget(self, action: "acceptFriendship:", forControlEvents: .TouchUpInside)
        cell.rejectButton.tag = getTagFromIndexPath(indexPath)
        cell.rejectButton.addTarget(self, action: "rejectFriendship:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Display a popup with information about the selected user
        let user = results[indexPath.row]
        let alertController = UIAlertController(title: user.username, message:
            "Here it will display a popup with information about the selected user", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let text = searchController.searchBar.text!
        if !text.isEmpty {
            Database.USER_REF.queryLimitedToFirst(25).observeSingleEventOfType(.Value, withBlock: { snapshot in
                self.results.removeAll()
                
                for snap in snapshot.children.allObjects as! [FDataSnapshot]{
                    let key = snap.key
                    let dictionary = snap.value as! [String: AnyObject]
                    let user = User(uid: key, dictionary: dictionary)
                    
                    // If the user is the current user, do not add them
                    if(user.uid == self.myFriendshipsRef?.key){continue}
                    
                    if user.firstname.lowercaseString.hasPrefix(text.lowercaseString){
                        self.results.append(user)
                    }else if(user.lastname.lowercaseString.hasPrefix(text.lowercaseString)){
                        self.results.append(user)
                    }else if(user.username.lowercaseString.hasPrefix(text.lowercaseString)){
                        self.results.append(user)
                    }
                }
                
                // Sort and reload the data
                self.results.sortInPlace({ $0.lastname > $1.lastname })
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: Selectors
    
    func addFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        let myId = myFriendshipsRef?.key
        let theirId = results[indexPath.row].uid
        
        // First we decide where to add the friendship
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
        // Now we add the appropriate friendship for each user
        myFriendshipsRef?.childByAppendingPath(theirId).setValue(FriendshipStatus.PendingSent.rawValue)
        theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.PendingReceived.rawValue)
    }
    
    func acceptFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        let myId = myFriendshipsRef?.key
        let theirId = results[indexPath.row].uid
        
        if let theirId = theirId{
            
            let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
            
            // Set the status to rejected
            myFriendshipsRef?.childByAppendingPath(theirId).setValue(FriendshipStatus.Accepted.rawValue)
            theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.Accepted.rawValue)
        }
    }
    
    func rejectFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        // Identify each users friendship reference
        let myId = myFriendshipsRef?.key
        let theirId = results[indexPath.row].uid
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
        // Set the status to rejected
        myFriendshipsRef?.childByAppendingPath(theirId).setValue(FriendshipStatus.Rejected.rawValue)
        theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.Rejected.rawValue)
    }
    
    // MARK: Misc

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
    
}