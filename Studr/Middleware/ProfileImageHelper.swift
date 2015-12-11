//
//  Gravitar.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import CryptoSwift
import Parse
import Haneke

/**
 The purpose of this function is to retrieve a users profile image
 
 - parameter user:      The user we want the image for
 - parameter onSuccess: The completion block that is called when we have the image
 */
func getProfileImageForUser(user: PFUser, onSuccess: (image: UIImage) -> ()){
    // Reference to the cache where the profile images are stored
    let cache = Shared.imageCache
    
    // Check the cache
    cache.fetch(key: user.objectId!, failure: { (error) -> () in
        let gravitar: UIImage? = getGravitarImageForEmail(user.email!)
        if(gravitar != nil){
            cache.set(value: gravitar!, key: user.objectId!)
            onSuccess(image: gravitar!)
            
        }else{
            let image = faceImageFromString(user.email!, size: CGSizeMake(80, 80))
            cache.set(value: image, key: user.objectId!)
            onSuccess(image: image)
        }
        }) { (image) -> () in
            onSuccess(image: image)
    }
}
func getGravitarImageForEmail(email : String) -> UIImage? {
    let urlString : String = "https://gravatar.com/avatar/" + email.md5() + "?d=404"
    if let imageURL = NSURL(string: urlString), let data = NSData(contentsOfURL: imageURL), let image = UIImage(data: data) {
        return image
    }
    return nil
}

func identiconFromString(string : String, size : CGSize) -> UIImage{
    let hash = string.md5()
    var pixels = [[false,false,false,false,false],
                [false,false,false,false,false],
                [false,false,false,false,false]]
    
    var color = UIColor(hexString: hash.substringWithRange(Range<String.Index>(start: hash.startIndex, end: hash.startIndex.advancedBy(6))))
    color = color.flatten()
    
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetShouldAntialias(context, false)
    
    // Find out which pixels should be turned on
    for var i = 0; i < 3; i++ {
        for var j = 0; j < 5; j++ {
            let string = hash.substringWithRange(Range<String.Index>(start: hash.startIndex.advancedBy((i * 5) + j), end: hash.startIndex.advancedBy((i * 5) + j + 1)))
            let value = UInt8(strtoul(string, nil, 16))
            
            if(value % 2 == 0){
                pixels[i][j] = !pixels[i][j]
            }
        }
    }

    color.colorWithAlphaComponent(0.25).setFill()
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
    
    color.setFill()
    let cellSize = CGSizeMake(size.width / 5, size.height / 5)
    for var i = 0; i < 15; i++ {
            let xa = i % 3
            let ya = i / 3
            if(pixels[xa][ya] == true){
                let drawPositionX : CGFloat = CGFloat(CGFloat(xa) * cellSize.width)
                let drawPositionY : CGFloat = CGFloat(CGFloat(ya) * cellSize.height)
                CGContextFillRect(context, CGRectMake(drawPositionX, drawPositionY, cellSize.width, cellSize.height))
                
                if (xa != 4 - xa) {
                    CGContextFillRect(context, CGRectMake(CGFloat(4 - xa) * cellSize.width, drawPositionY, cellSize.width, cellSize.height))
                }
        }
    }
    
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image;
}

func faceImageFromString(string : String, size : CGSize) -> UIImage{
    let hash = string.md5()
    
    // Find the color based on the first six letters of the hash
    //var color = UIColor(hexString: hash.substringWithRange(Range<String.Index>(start: hash.startIndex, end: hash.startIndex.advancedBy(6))))
    var color = UIColor(hexString: "#D4D4D4")
    //color = color.flatten()
    
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetShouldAntialias(context, false)
    
    color.setFill()
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
    
    let face = hash.substringWithRange(Range<String.Index>(start: hash.startIndex.advancedBy(6), end: hash.startIndex.advancedBy(7)))
    var faceImage = UIImage()
    switch(face){
    case "0": faceImage = UIImage(named: "face_01")! ; break
    case "1": faceImage = UIImage(named: "face_02")! ; break
    case "2": faceImage = UIImage(named: "face_03")! ; break
    case "3": faceImage = UIImage(named: "face_04")! ; break
    case "4": faceImage = UIImage(named: "face_05")! ; break
    case "5": faceImage = UIImage(named: "face_06")! ; break
    case "6": faceImage = UIImage(named: "face_07")! ; break
    case "7": faceImage = UIImage(named: "face_08")! ; break
    case "8": faceImage = UIImage(named: "face_09")! ; break
    case "9": faceImage = UIImage(named: "face_10")! ; break
    case "a": faceImage = UIImage(named: "face_11")! ; break
    case "b": faceImage = UIImage(named: "face_01")! ; break
    case "c": faceImage = UIImage(named: "face_06")! ; break
    case "d": faceImage = UIImage(named: "face_09")! ; break
    case "e": faceImage = UIImage(named: "face_10")! ; break
    case "f": faceImage = UIImage(named: "face_11")! ; break
    default: break
    }
    faceImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
   
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image;
}