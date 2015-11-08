//
//  CreateGroupViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/5/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import XLForm

class CreateGroupViewController: XLFormViewController {
    
    // Items to be created in form
    private struct Tags {
        static let Title        = "title"
        static let Description  = "description"
        static let Location     = "location"
        static let Access       = "access"
        static let Private      = "private"
        static let Members      = "members"
        static let Submit       = "submit"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Create Group")
        form.assignFirstResponderOnShow = false
        
        section = XLFormSectionDescriptor.formSection()
        section.sectionOptions
        form.addFormSection(section)
        
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.Title, rowType: XLFormRowDescriptorTypeText)
        row.required = true
        row.cellConfigAtConfigure["textField.placeholder"] = "Title"
        row.cellConfig["self.tintColor"] = UIColor(hexString: "F68E20")
        section.addFormRow(row)
        
        // Description
        row = XLFormRowDescriptor(tag: Tags.Description, rowType: XLFormRowDescriptorTypeTextView)
        row.required = false
        row.cellConfigAtConfigure["textView.placeholder"] = "Description"
        row.cellConfig["self.tintColor"] = UIColor(hexString: "F68E20")
        section.addFormRow(row)
        
        // Locaiton
        row = XLFormRowDescriptor(tag: Tags.Location, rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Location"
        row.required = true
        row.cellConfig["self.tintColor"] = UIColor(hexString: "F68E20")
        section.addFormRow(row)
        
        // Private
        row = XLFormRowDescriptor(tag: Tags.Private, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Private")
        row.required = false
        row.cellConfig["self.tintColor"] = UIColor(hexString: "F68E20")
        section.addFormRow(row)
        
        // Members
        row = XLFormRowDescriptor(tag: Tags.Members, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Add Members")
        row.required = false
        row.cellConfig["self.tintColor"] = UIColor(hexString: "F68E20")
        //row.action.viewControllerClass = FriendsTableViewController.self
        section.addFormRow(row)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // Selector PopOver
            row = XLFormRowDescriptor(tag: "selectorUserPopover", rowType:XLFormRowDescriptorTypeSelectorPopover, title:"Members")
            //row.action.viewControllerClass = FriendsTableViewController.self
            section.addFormRow(row)
        }
        
        //Submit
        row = XLFormRowDescriptor(tag: Tags.Submit, rowType: XLFormRowDescriptorTypeButton, title: "Submit")
        row.cellConfig["backgroundColor"] = UIColor(hexString: "13EB91")
        row.cellConfig["textLabel.textColor"] = UIColor.whiteColor()
        row.action.formSelector = "submitTapped:";
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    private func submitTapped(sender: UIButton){
        
        // Dictionary of results
        // var dictionary:Dictionary = self.formValues()
        
        
        // Store in database here
        
        // Move on
        
    }
    
    // MARK: Actions
    
    @IBAction func sideMenuToggleAction(sender: AnyObject) {
        let drawerViewController: DrawerViewController = self.view.window!.rootViewController as! DrawerViewController
        drawerViewController.setPaneState(.Open, animated: true, allowUserInterruption: true, completion: nil)
        
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Override row height here
        if (form.formRowAtIndex(indexPath)?.tag != "description"){
            return 64
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
}