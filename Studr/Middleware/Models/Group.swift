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
    
    // MARK: Instance Variables
    
    var ref: Firebase!
    var key: String!
    var name = String()
    var members = [String:String]()
    
    // MARK: Constructors
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.key = key
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let members = dictionary["members"] as? [String:String]{
            self.members = members
        }
        
        ref = Database.GROUP_REF.childByAppendingPath(key)
    }
}