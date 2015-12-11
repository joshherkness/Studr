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

public class SetAvailabilityViewController: FormViewController,TypedRowControllerType {
    
    // Variables used for eureka row reference and callback
    public var row: RowOf<String>!
    public var completionCallback : ((UIViewController) -> ())?
    
    public var parseRelationName: String?

    convenience public init(_ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override public func didReceiveMemoryWarning() {
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