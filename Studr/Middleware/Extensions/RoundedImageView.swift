//
//  CircularImageView.swift
//  Studr
//
//  Created by Joseph Herkness on 12/11/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    // MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5.0
    }
}