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
        event["public"] = false
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
    static func getUsersEvents(user: PFUser, blockSuccess: (events: [PFObject])->Void, blockFail: (error: NSError) ->Void) -> Void {
        let eventsQuery = PFQuery(className: "Group")
        eventsQuery.whereKey("members", equalTo: user)
        eventsQuery.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if(error == nil){
                blockSuccess(events: events!)
            }else{
                blockFail(error: error!)
            }
        }
    }
//    static func findEventsWithTag(eventTag: String) -> Void {
//        
//    }
    static func getlocalEvents(location: PFGeoPoint, radius: Double,blockSuccess: (events: [PFObject])->Void, blockFail: (error: NSError) ->Void) -> Void {
        let eventsQuery = PFQuery(className: "Group")
        eventsQuery.whereKey("location", nearGeoPoint: location, withinMiles: radius)
        eventsQuery.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if(error == nil){
                blockSuccess(events: events!)
            }else{
                blockFail(error: error!)
            }
        }
    }
//    static func getlocalPrivateEvents() -> Void {
//        
//    }
//    static func getlocalPublicEvents() -> Void {
//        
//    }
//    static func getpendingEvents() -> Void {
//        
//    }
//    static func getuserEvents() -> Void {
//        
//    }
//    static func joinEvent(eventName: String) -> Void {
//        
//    }
//    static func joinEventWithID(eventID: String) -> Void {
//        
//    }
//    static func leaveEvent(eventName: String) -> Void {
//        
//    }
    
}
