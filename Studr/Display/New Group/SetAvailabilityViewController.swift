//
//  SetAvailabilityViewController.swift
//  Studr
//
//  Created by Robin Onsay on 12/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Parse

class SetAvailabilityViewController: FormViewController {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}