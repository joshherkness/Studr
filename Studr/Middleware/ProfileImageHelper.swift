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
    var urlString : String = "https://gravatar.com/avatar/" + email.md5() + "?d=retro"
    urlString = "https://github.com/identicons/" + email.md5() + ".png"
    //urlString = "https://robohash.org/" + email.md5()
    if let imageURL = NSURL(string: urlString), let data = NSData(contentsOfURL: imageURL), let image = UIImage(data: data) {
        return image
    }
    
    return UIImage(named: "placeholder_profile_male")!
}

func imageFromString(string : String, size : CGSize) -> UIImage{
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