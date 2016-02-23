//
//  SettingsViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Haneke

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Settings"
        
        // Create the form
        form +++ Section("")
            <<< ButtonRow("editProfile") {
                $0.title = "Edit Profile"
                $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return EditProfileViewController() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
                }
        
        form +++ Section("")
            <<< SwitchRow("notificationSwitch"){
                $0.title = "Notifications"
                }.onChange{ row in
                    // TODO: Toggle notifications here
                }
        
        form +++ Section("")
            <<< ButtonRow("about") {
                    $0.title = "About"
                    $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return AboutViewController() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
                    }
            <<< ButtonRow("help") {
                $0.title = "Help"
                $0.presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return AboutViewController() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
                    }
            <<< ButtonRow("recommend") {
                $0.title = "Recommend Studr"
                }.cellSetup({ cell, row in
                    cell.tintColor = Constants.Color.primary
                }).cellUpdate{ cell, row in
                    cell.textLabel?.textAlignment = .Left
        }
        
        form +++ Section("")
            <<< ButtonRow("signOut") {
                $0.title = "Log Out"
                }.cellSetup { cell, row in
                    cell.tintColor = Constants.Color.red
                }.cellUpdate{ cell, row in
                    cell.textLabel?.textAlignment = .Left
                }.onCellSelection { cell, row in
                    self.signOut(true)
                }
    }
    
    // MARK: Authentication Methods
    
    private func signOut(requireVerification: Bool = false){
        
        // Unauthenticate the current user
        Database.BASE_REF.unauth()
    }
}