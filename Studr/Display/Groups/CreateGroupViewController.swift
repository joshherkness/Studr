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
    
    private var createButton: UIBarButtonItem = UIBarButtonItem()
    private var cancelButton: UIBarButtonItem = UIBarButtonItem()
    
    private var name: String = ""
    private var members: [String] = []
    
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
        createButton = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "create")
        createButton.enabled = false
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
            createButton.enabled = true
        }else{
            createButton.enabled = false
        }
    }
    
    func create(){
        // Add the appropriate information to the database
        let groupRef = Constants.ref.childByAppendingPath("groups").childByAutoId()
        let groupNameRef = groupRef.childByAppendingPath("name")
        let groupMembersRef = groupRef.childByAppendingPath("members")
        
        groupNameRef.setValue(name)
        
        for member in members {
            let groupId = groupRef.key
            let membershipsRef = Constants.ref.childByAppendingPath("memberships").childByAppendingPath(member)
            
            groupMembersRef.childByAppendingPath(member).setValue(MembershipStatus.PendingSent.rawValue)
            membershipsRef.childByAppendingPath(groupId).setValue(MembershipStatus.PendingReceived.rawValue)
        }
        
        // Dismiss the view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
}