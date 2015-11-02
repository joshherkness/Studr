//
//  Database.swift
//  Studr
//
//  Created by Robin Onsay on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import Parse

class Database: DataBaseHelper {
    static func createEventWithBlock(eventName: String, eventDate: NSDate, eventDuration: Int, blockSuccess: () -> Void, blockFail: () ->Void) -> Void{
        var event = PFObject(className:"Group")
        
        event["title"] = eventName
        event["date"] = eventDate
        event["duration"] = eventDuration
        event.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success){
                blockSuccess()
            }else{
                blockFail()
            }
        }
        
        
    }
    static func destroyEvent(eventName: String) -> Bool {
        
    }
    static func findEventsWithName(eventName: String) -> [PFObject] {
        
    }
    static func findEventsWithTag(eventTag: String) -> [PFObject] {
        
    }
    static func getlocalEvents() -> [PFObject] {
        
    }
    static func getlocalPrivateEvents() -> [PFObject] {
        
    }
    static func getlocalPublicEvents() -> [PFObject] {
        
    }
    static func getpendingEvents() -> [PFObject] {
        
    }
    static func getuserEvents() -> [PFObject] {
        
    }
    static func joinEvent(eventName: String) -> Bool {
        
    }
    static func joinEventWithID(eventID: String) -> Bool {
        
    }
    static func leaveEvent(eventName: String) -> Bool {
        
    }
    
}
