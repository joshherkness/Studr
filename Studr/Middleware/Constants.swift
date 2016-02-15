//
//  Constants.swift
//  Studr
//
//  Created by Joseph Herkness on 12/6/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Firebase

struct Constants {
    
    struct Color {
        
        // Colors
        static let red = UIColor(hexString: "F54A4A")
        static let green = UIColor(hexString: "40B771")
        static let blue = UIColor(hexString: "3F4E98")
        static let purple = UIColor(hexString: "C02942")
        static let lightGrey = UIColor(hexString: "EFEFF4")
        static let grey = UIColor(hexString: "DEE0E4")
        static let darkGrey = UIColor(hexString: "353535")
        
        // Theme colors
        static let primary = UIColor(hexString: "2297F4")
        static let lightGreyBackground = UIColor(hexString: "ECEEEF")
        // Tab colors
        static let barTintColor = UIColor(hexString: "F6F8FA")
        static let selectedTabColor = UIColor(hexString: "2288DC")
        static let deselectedTabColor = UIColor(hexString: "8B9399")
    }
    
    static let userCellHeight: CGFloat = 56.0
}
