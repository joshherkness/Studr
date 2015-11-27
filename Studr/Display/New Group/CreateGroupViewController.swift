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
import Parse

class CreateGroupViewController : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextRow.defaultCellUpdate = {cell, row in
            cell.tintColor = STColor.red()
            cell.textField.textAlignment = .Left
        }
        
        form +++ Section("What should we call it?")
            <<< TextRow("title"){
                $0.placeholder = "Title"}
            <<< PFUserMultipleSelectorRow("inviteFriends"){
                let set = Set<PFUser>(arrayLiteral: PFUser.currentUser()!)
                $0.options = [PFUser.currentUser()!]
                $0.value = [PFUser.currentUser()!]
                $0.title = "Invite Friends"
            }
        form +++ Section(""){
                $0.hidden = "$title == nil"
            }
            <<< TextAreaRow("description"){
                $0.placeholder = "Description"
                $0.hidden = .Function(["title"], { form -> Bool in
                    let row: RowOf<String>! = form.rowByTag("title")
                    return row.value == nil
                })}
            <<< ButtonRow("members"){
                $0.title = "Members"
                $0.presentationMode = .SegueName(segueName: "AddMembersTableViewController", completionCallback:{  vc in vc.dismissViewControllerAnimated(true, completion: nil) })
            }
            <<< SwitchRow("access"){
                $0.title = "Private"
                $0.value = false}
    }
}