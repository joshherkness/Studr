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
    
    private var ref: Firebase!
    private var key: String!
    
    private var name: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.key = key
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        ref = Database.GROUP_REF.childByAppendingPath(key)
    }
    
}