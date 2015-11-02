//
//  Database.swift
//  Studr
//
//  Created by Robin Onsay on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import Parse

class Database{
    static func createEventWithBlock(eventName: String, eventDate: NSDate, eventDuration: Int, blockSuccess: () -> Void, blockFail: (error: NSError) ->Void) -> Void{
        let event = PFObject(className:"Group")
        
        event["title"] = eventName
        event["date"] = eventDate
        event["duration"] = eventDuration
        event.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success){
                blockSuccess()
            }else{
                blockFail(error: error!)
            }
        }
        
        
    }
    static func destroyEvent(eventID: String, blockSuccess: ()->Void, blockFail: (error: NSError) ->Void) -> Void {
        let eventQuery = PFQuery(className: "Group")
        eventQuery.getObjectInBackgroundWithId(eventID) { (event: PFObject?, error: NSError?) -> Void in
            if error == nil && event != nil{
                event?.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if(success){
                        blockSuccess()
                    }else{
                        blockFail(error: error!)
                    }
                })
            }else{
                blockFail(error: error!)
            }
        }
        
        
    }
    static func getUsersEvents(blockSuccess: (events: [PFObject])->Void, blockFail: (error: NSError) ->Void) -> Void{
        let eventsQuery = PFQuery(className: "Group")
        eventsQuery.whereKey("members", equalTo: PFUser.currentUser()!)
        eventsQuery.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if(error == nil){
                blockSuccess(events: events!)
            }else{
                blockFail(error: error!)
            }
        }

    }
//    static func getUsersEvents(user: PFUser) -> [PFObject] {
//        
//    }
//    static func findEventsWithTag(eventTag: String) -> [PFObject] {
//        
//    }
//    static func getlocalEvents() -> [PFObject] {
//        
//    }
//    static func getlocalPrivateEvents() -> [PFObject] {
//        
//    }
//    static func getlocalPublicEvents() -> [PFObject] {
//        
//    }
//    static func getpendingEvents() -> [PFObject] {
//        
//    }
//    static func getuserEvents() -> [PFObject] {
//        
//    }
//    static func joinEvent(eventName: String) -> Bool {
//        
//    }
//    static func joinEventWithID(eventID: String) -> Bool {
//        
//    }
//    static func leaveEvent(eventName: String) -> Bool {
//        
//    }
    
}
