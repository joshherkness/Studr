//
//  HeaderView.swift
//  Studr
//
//  Created by Joseph Herkness on 2/21/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HeaderView: UIView {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self)
        }
        
        backgroundColor = UIColor(hexString: "F4F5F6")
        titleLabel.textColor = UIColor(hexString: "8A9299")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}