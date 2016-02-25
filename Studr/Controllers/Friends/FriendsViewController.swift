//
//  FriendViewController2.swift
//  Studr
//
//  Created by Joseph Herkness on 2/15/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FriendsViewController: UITableViewController, UISearchControllerDelegate {
    
    // MARK: Instance Variables
    
    private var sections = ["Added Me", "My Friends"]
    private var friends: [[User]] = [[], []]
    
    private var searchController: UISearchController?
    private var searchResultsController: SearchFriendsTableViewController?
    private var results = [User]()
    
    private var myFriendshipsRef: Firebase?
    private var friendshipAddedHandle: FirebaseHandle!
    private var friendshipChangedHandle: FirebaseHandle!
    private var friendshipRemovedHandle: FirebaseHandle!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true
        navigationItem.title = "Friends"
        
        // Setup the tableview
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: "UserCell")
        
        // Change the table view background color
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor.whiteColor()
        tableView.backgroundColor = UIColor.whiteColor()
        
        // SearchResultsController
        searchResultsController = SearchFriendsTableViewController()
        
        // Search Controller
        searchController = UISearchController(searchResultsController: searchResultsController!)
        searchController?.searchResultsUpdater = searchResultsController!
        searchController?.delegate = self
        tableView.tableHeaderView = self.searchController?.searchBar
        definesPresentationContext = true
        
        // Setup the search bar
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Find friends"
        searchController?.searchBar.barTintColor = UIColor.whiteColor()
        searchController?.searchBar.tintColor = Color.primary
        searchController?.searchBar.layer.borderWidth = 1;
        searchController?.searchBar.layer.borderColor = UIColor.whiteColor().CGColor
        tableView.setContentOffset(CGPointMake(0, searchController!.searchBar.frame.size.height), animated:false)
        
        // Firebase
        if let authData = Database.BASE_REF.authData {
            myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(authData.uid)
            myFriendshipsRef?.keepSynced(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        beginObserving()
    }
    
    override func viewDidDisappear(animated: Bool) {
        myFriendshipsRef?.removeAllObservers()
    }
    
    func beginObserving(){
        
        // Empty the list of friends
        for (var i = 0; i < friends.count; i++) { friends[i].removeAll() }
        
        friendshipAddedHandle = myFriendshipsRef?.observeEventType(.ChildAdded, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            Database.getUser(theirId) { user in
                
                if(status == FriendshipStatus.PendingReceived.rawValue){
                    self.friends[0].append(user)
                }else if(status == FriendshipStatus.Accepted.rawValue){
                    self.friends[1].append(user)
                }
                
                self.tableView.reloadData()
            }
        })
        
        friendshipChangedHandle = myFriendshipsRef?.observeEventType(.ChildChanged, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            
            Database.getUser(theirId) { user in
                
                for (var i = 0; i < self.friends.count; i++){
                    self.friends[i] = self.friends[i].filter({ $0.uid != user.uid })
                }
                if(status == FriendshipStatus.PendingReceived.rawValue){
                    self.friends[0].append(user)
                }else if(status == FriendshipStatus.Accepted.rawValue){
                    self.friends[1].append(user)
                }
                
                self.results = self.results.filter({ $0.uid != user.uid })
                self.results.append(user)
                
                self.tableView.reloadData()
            }
        })
        
        friendshipRemovedHandle = myFriendshipsRef?.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let theirId = snapshot.key
            
            Database.getUser(theirId) { user in
                
                for (var i = 0; i < self.friends.count; i++){
                    self.friends[i] =  self.friends[i].filter({ $0.uid != user.uid })
                }
                
                self.tableView.reloadData()
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
    
    func addFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        let myId = myFriendshipsRef?.key
        let theirId = friends[indexPath.section][indexPath.row].uid
        
        // First we decide where to add the friendship
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
        // Now we add the appropriate friendship for each user
        myFriendshipsRef?.childByAppendingPath(theirId).setValue(FriendshipStatus.PendingSent.rawValue)
        theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.PendingReceived.rawValue)
    }
    
    func acceptFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        let myId = myFriendshipsRef?.key
        let theirId = friends[indexPath.section][indexPath.row].uid
        
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
        let theirId = friends[indexPath.section][indexPath.row].uid
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
        // Set the status to rejected
        myFriendshipsRef?.childByAppendingPath(theirId).setValue(FriendshipStatus.Rejected.rawValue)
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
        return Config.userCellHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Determine the user that the cell should display
        let user = friends[indexPath.section][indexPath.row]

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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView()
        header.titleLabel.text = sections[section]
        
        return header
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
    
    func willPresentSearchController(searchController: UISearchController) {
        navigationController?.navigationBar.translucent = true;
    }

    func willDismissSearchController(searchController: UISearchController) {
        navigationController?.navigationBar.translucent = false;
    }
    
}