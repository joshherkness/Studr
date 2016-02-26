//
//  CustomCells.swift
//  Studr
//
//  Created by Joseph Herkness on 2/23/16.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka

// TODO: Create a custom cell type for this row

public final class MembersSelectorRow : GenericMultipleSelectorRow<User, AddMembersTableViewController >, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return AddMembersTableViewController(){ _ in } }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
        
        self.displayValueFor = {
            if let t = $0 {
                return t.count == 1 ? "\(t.count) member" : "\(t.count) members"
            }
            return nil
        }
    }
}