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
import CryptoSwift

// TODO: Rewrite this class so that is does not use PFQueryTableViewController or UISearchBarDelegate

public class AddMembersTableViewController: PFQueryTableViewController , UISearchBarDelegate, TypedRowControllerType {
    
    // MARK: Instance Variables
    public var row: RowOf<Set<PFUser>>!
    public var completionCallback : ((UIViewController) -> ())?
    public var parseRelationName: String?
    public var selectedFriends = [PFObject]()
    var query: PFQuery?
    
    convenience public init(_ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }

    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        placeholderImage = UIImage(named: "placeholder_profile_male")
        imageKey = "profileImage"
        textKey = "username"

        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        
        // Allows selection of multiple cells in tableview
        tableView.allowsMultipleSelection = true
        
        // Add completion button
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.leftBarButtonItem = button
        
        // Load the existing selected users into the array
        selectedFriends = Array(row.value!)
        
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
        
        // Return to previouse view controller
        self.navigationController?.popViewControllerAnimated(true)
    }

    //MARK: UITableViewDelegate
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // To be called when a cell is seclected
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UserCell
        let object = self.objectAtIndexPath(indexPath)!
        
        selectedFriends.append(object)
        cell?.accessoryType = .Checkmark
        cell?.nameLabel.textColor = Constants.Color.primary
    }
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UserCell
        let object = self.objectAtIndexPath(indexPath)!
        
        let filteredSelectedFriends: [PFObject] = selectedFriends.filter({ $0.objectId == object.objectId })
        let filteredSelectedFriendsObject = filteredSelectedFriends.first
        
        selectedFriends.removeAtIndex(selectedFriends.indexOf(filteredSelectedFriendsObject!)!)
        cell?.accessoryType = .None
        cell?.nameLabel.textColor = UIColor.blackColor()
    }
    
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
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
    
    //MARK: UITableViewDataSource
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let user = object as? PFUser
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        
        // If the user exists, set the cell's user
        if let user = user{
            cell.setUser(user)
        }else{
            cell.profileImageView.image = object![imageKey!] != nil ? object![imageKey!] as? UIImage : placeholderImage
        }
        
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = Constants.Color.primary.colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Determine if the friend should be selected
        let results: [PFObject] = selectedFriends.filter({ $0.objectId == object!.objectId })
        
        if !results.isEmpty {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        }

        cell.accessoryType = cell.selected ? .Checkmark : .None
        cell.nameLabel.textColor = cell.selected ? Constants.Color.primary : UIColor.blackColor()
        cell.tintColor = Constants.Color.primary
        
        return cell
    }
    
    
    // Mark - PFQueryTableViewController
    
    public override func queryForTable() -> PFQuery {
        
        let friendsRelation = PFUser.currentUser()?.relationForKey("friend")
        query = friendsRelation?.query()
        query?.orderByAscending("username")
        
        return query!
    }

}
