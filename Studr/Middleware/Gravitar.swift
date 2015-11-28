//
//  Gravitar.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import CryptoSwift

func getGravitarImageForEmail(email : String) -> UIImage {
    let urlString : String = "https://gravatar.com/avatar/" + email.md5() + "?d=retro"
    if let imageURL = NSURL(string: urlString), let data = NSData(contentsOfURL: imageURL), let image = UIImage(data: data) {
        return image
    }
    
    return UIImage(named: "placeholder_profile_male")!
}