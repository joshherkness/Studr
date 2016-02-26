//
//  Group.swift
//  Studr
//
//  Created by Joseph Herkness on 2/14/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import Firebase

class Group {
    
    var ref: Firebase!
    var key = String()
    var name = String()
    var members = [String:String]()
    
    // MARK: Constructors
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self.key = key
        ref = Database.GROUP_REF.childByAppendingPath(key)
        name = dictionary["name"] as? String ?? ""
        members = dictionary["first_name"] as? [String:String] ?? [String:String]()
    }
}