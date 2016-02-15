//
//  GroupCell.swift
//  Studr
//
//  Created by Joseph Herkness on 2/14/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit

class GroupCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeCell()
    }
    
    func initializeCell(){
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        
    }
    
    func configureCell(group: Group){
        nameLabel.text = group.name
    }
}