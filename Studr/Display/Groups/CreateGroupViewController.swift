//
//  CreateGroupViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/5/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class CreateGroupViewController : FormViewController {
    
    // MARK: Instance Variables
    
    private var createButton: UIBarButtonItem?
    private var cancelButton: UIBarButtonItem?
    
    private var name = String()
    private var members = [User]()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Create"
        
        // Add Cancel button
        cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        navigationItem.setLeftBarButtonItem(cancelButton, animated: false)
        
        // Add Create button
        createButton = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "createGroup")
        createButton?.enabled = false
        navigationItem.setRightBarButtonItem(createButton, animated: false)
        
        // Create Form
        
        form +++ Section("")
            <<< TextRow("name"){
                $0.placeholder = "Name your group"}.onChange({ row in
                    if let _ = row.value {
                        self.name = row.value! as String
                    }else{
                        self.name = ""
                    }
                    self.validate()
                })
            <<< MembersSelectorRow("addMembers"){
                $0.value = []
                $0.title = "Add Members"}.onChange({ row in
                    self.members = Array(row.value!)
                    self.validate()
                })
    }
    
    func cancel(){
        // Dismiss the view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Checks to make sure all the inputs are valid
    func validate(){
        if(!name.isEmpty){
            createButton?.enabled = true
        }else{
            createButton?.enabled = false
        }
    }
    
    func createGroup(){
        // Add the appropriate information to the database
        let groupRef = Database.GROUP_REF.childByAutoId()
        let groupMembersRef = groupRef.childByAppendingPath("members")
        let groupId = groupRef.key
        
        // Set the name of the group
        groupRef.childByAppendingPath("name").setValue(name)
        
        // Add the current user to the group as the creator
        let myId = Database.BASE_REF.authData.uid
        let myMembershipsRef = Database.MEMBERSHIP_REF.childByAppendingPath(myId)
        groupMembersRef.childByAppendingPath(myId).setValue(MembershipStatus.Created.rawValue)
        myMembershipsRef.childByAppendingPath(groupId).setValue(MembershipStatus.Created.rawValue)
        
        // Add each member to the group
        for member in members {
            let membershipsRef = Database.MEMBERSHIP_REF.childByAppendingPath(member.uid)
            
            groupMembersRef.childByAppendingPath(member.uid).setValue(MembershipStatus.PendingSent.rawValue)
            membershipsRef.childByAppendingPath(groupId).setValue(MembershipStatus.PendingReceived.rawValue)
        }
        
        // Dismiss the view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
}