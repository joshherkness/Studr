//
//  ProfileImageHelper.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import CryptoSwift
import Haneke

func getProfileImageForUser(user: String, email: String, onSuccess: (image: UIImage) -> ()){
    
    // Reference to the cache where the profile images are stored
    let cache = Shared.imageCache
    
    // Check the cache
    cache.fetch(key: user, failure: { error in
        if let gravitar = getGravitarImageForEmail(email){
            cache.set(value: gravitar, key: user)
            onSuccess(image: gravitar)
        }else{
            let image = placeholderImage(email)
            cache.set(value: image, key: user)
            onSuccess(image: image)
        }
        }) { image in
            onSuccess(image: image)
    }
}

func getGravitarImageForEmail(email: String) -> UIImage? {
    let urlString : String = "https://gravatar.com/avatar/" + email.md5() + "?d=404"
    if let imageURL = NSURL(string: urlString), let data = NSData(contentsOfURL: imageURL), let image = UIImage(data: data) {
        return image
    }
    return nil
}

func placeholderImage(email: String) -> UIImage{
    let hash = email.md5()
    let size = CGSize(width: 80, height: 80)
    
    // Get the color
    var color = Color.grey
    color = UIColor(hexString: hash.substringToIndex(hash.startIndex.advancedBy(6)))
    color = color.flatten().colorWithAlphaComponent(0.5)
    
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetShouldAntialias(context, false)
    
    color.setFill()
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
    
    // Now we decide which face to use for the given user
    let faceImage = UIImage(named: "face")!
    faceImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
   
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image;
}