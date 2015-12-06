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
        
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = Constants.Color.primary
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Create"
        
        // Add dismiss button
        let closeImage = UIImage(named: "ic_clear")
        let dismissButton = UIBarButtonItem(image: closeImage, style: .Plain, target: self, action: "dismiss:")
        navigationItem.leftBarButtonItem = dismissButton
        
        // Add completion button
        let doneImage = UIImage(named: "ic_done")
        let completeButton = UIBarButtonItem(image: doneImage, style: .Plain, target: self, action: "complete:")
        navigationItem.rightBarButtonItem = completeButton
        
        // Create Form
        TextRow.defaultCellUpdate = {cell, row in
            cell.tintColor = Constants.Color.primary
            cell.textField.textAlignment = .Left
        }
        
        form +++ Section("What should we call it?")
            <<< TextRow("title"){
                $0.placeholder = "Title"}
        form +++ Section(""){
                $0.hidden = "$title == nil"
            }
            <<< TextAreaRow("description"){
                $0.placeholder = "Description"
                $0.hidden = .Function(["title"], { form -> Bool in
                    let row: RowOf<String>! = form.rowByTag("title")
                    return row.value == nil
                })}
            <<< PFUserSelectorRow("inviteFriends"){
                $0.value = []
                $0.title = "Invite Friends"}
            <<< SwitchRow("shareOnFacebook"){
                $0.title = "Share on Facebook"
                $0.value = false}
    }
    
    func dismiss(sender: UIBarButtonItem){
        // Dismiss view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func complete(sender: UIBarButtonItem){
        // Perform database storage here
        
        // Dismiss view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}