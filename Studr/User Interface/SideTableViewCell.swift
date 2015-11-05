//
//  SideTableViewCell.swift
//  Studr
//
//  Created by Joshua Herkness on 11/4/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit

class SideTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTagView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
