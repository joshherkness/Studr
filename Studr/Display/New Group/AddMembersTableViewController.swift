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
import ParseUI
import Eureka

class AddMembersTableViewController: PFQueryTableViewController , UISearchBarDelegate, TypedRowControllerType {
    
    var row: RowOf<Set<PFUser>>!
    var completionCallback : ((UIViewController) -> ())?
  
    // Array of current selected friends within the table
    var selectedFriends = [PFObject]()
    
    // Search Bar
    var searchBar = UISearchBar()
    
    // The current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            //oldValue?.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        
        // Allows selection of multiple cells in tableview
        tableView.allowsMultipleSelection = true
        
        // Create the search bar view
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Username"
        searchBar.searchBarStyle = .Minimal
        searchBar.showsCancelButton = true
        
        //Change the appearance of the search bar
        searchBar.setImage(UIImage(named: "SearchIcon"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        textFieldInsideSearchBar?.textAlignment = .Left
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "beganSearch")
        
        // Add completion button
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
        
        // Load the existing selected users into the array
        for v in row.value! {
            selectedFriends.append(v)
        }
        
        // Reload the data of the table
        loadObjects()
        
    }
    
    func tappedDone(sender: UIButton){
        
        // Set the new value of selected friends
        var selectedFriendsSet = Set<PFUser>()
        for s in selectedFriends {
            selectedFriendsSet.insert(s as! PFUser)
        }
        row.value = selectedFriendsSet
    }

    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // To be called when a cell is seclected
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? FriendTableViewCell
        let object = self.objectAtIndexPath(indexPath)!
        
        selectedFriends.append(object)
        cell?.accessoryType = .Checkmark
        cell?.friendName.textColor = STColor.blue()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? FriendTableViewCell
        let object = self.objectAtIndexPath(indexPath)!
        
        let filteredSelectedFriends: [PFObject] = selectedFriends.filter({ $0.objectId == object.objectId })
        let filteredSelectedFriendsObject = filteredSelectedFriends.first
        
        selectedFriends.removeAtIndex(selectedFriends.indexOf(filteredSelectedFriendsObject!)!)
        cell?.accessoryType = .None
        cell?.friendName.textColor = UIColor.blackColor()
        
        print(selectedFriends)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        cell.friendName.text = object!["username"] as? String
        
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Determine if the friend should be selected
        let results: [PFObject] = selectedFriends.filter({ $0.objectId == object!.objectId })
        
        if !results.isEmpty {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        }

        cell.accessoryType = cell.selected ? .Checkmark : .None
        cell.friendName.textColor = cell.selected ? STColor.blue() : UIColor.blackColor()
        cell.tintColor = STColor.blue()
        
        return cell
    }
    

    
    // Mark: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadObjects()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.navigationItem.titleView = nil
        
        let searchButton = UIBarButtonItem.init(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "beganSearch")
        self.navigationItem.setRightBarButtonItem(searchButton, animated: true)
        loadObjects()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.navigationItem.titleView = nil
        
        let searchButton = UIBarButtonItem.init(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "beganSearch")
        self.navigationItem.setRightBarButtonItem(searchButton, animated: true)
        loadObjects()
    }
    
    func beganSearch(){
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.titleView = searchBar
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
        searchBar.becomeFirstResponder()
    }
    
    
    // Mark - PFQueryTableViewController
    
    override func queryForTable() -> PFQuery {
        
        let friendsRelation = PFUser.currentUser()?.relationForKey("friend")
        query = friendsRelation?.query()
        
        if (self.searchBar.text?.characters.count > 0){
            query?.cachePolicy = .CacheOnly
            query?.whereKey("username", containsString: searchBar.text!.lowercaseString)
        }
        query?.orderByAscending("username")
        
        return query!
    }

}
