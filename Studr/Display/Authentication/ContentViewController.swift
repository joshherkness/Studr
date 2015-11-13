//
//  ContentViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/13/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var pageIndex : Int!
    var titleText : String!
    
    override func viewDidLoad() {
        self.titleLabel.text = titleText
    }
}
