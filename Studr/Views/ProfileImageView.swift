//
//  ProfileImageView.swift
//  Studr
//
//  Created by Joseph Herkness on 2/26/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit

class ProfileImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = Config.cornerRadius
    }
    
    func setUser(user: User){
        image = nil
        getProfileImageForUser(user.uid, email: user.email, onSuccess: { image in
            self.image = image
        })
    }
}