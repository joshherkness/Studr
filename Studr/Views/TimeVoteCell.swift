//
//  TimeCollectionViewCell.swift
//  Studr
//
//  Created by Joseph Herkness on 2/24/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit

class TimeVoteCell: UICollectionViewCell {
    
    // MARK: Instance Variables
    
    private var timeLabel: UILabel!
    private var votesLabel: UILabel!
    
    // MARK: UICollectionViewCell
    
    override init(frame: CGRect) {
        super.init(frame: frame) 
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 2
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        timeLabel = UILabel()
        timeLabel.textAlignment = .Center
        timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        addSubview(timeLabel)
        
        votesLabel = UILabel()
        votesLabel.textAlignment = .Center
        votesLabel.font = UIFont(name: "HelveticaNeue-Medium", size:20.0)
        addSubview(votesLabel)
        
        updateConstraints()
    }
    
    func configureCell(votes: Int, date: NSDate){
        setTime(date)
        setVotes(votes)
    }
    
    func setTime(date: NSDate){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm"
        timeLabel.text = dateFormatter.stringFromDate(date)
    }
    
    func setVotes(votes: Int){
        votesLabel.text = String(votes)
    }
    
    override func updateConstraints() {
        timeLabel.snp_makeConstraints(closure: { make in
            make.bottom.left.right.equalTo(self)
            make.top.equalTo(votesLabel.snp_bottom)
        })
        
        votesLabel.snp_makeConstraints(closure: { make in
            make.top.right.left.equalTo(self)
            make.bottom.equalTo(timeLabel.snp_top)
        })
        
        super.updateConstraints()
    }
    
    func select(){
        backgroundColor = Color.primary
        timeLabel.textColor = UIColor.whiteColor()
        votesLabel.textColor = UIColor.whiteColor()
        votesLabel.alpha = 1.0
        timeLabel.alpha = 1.0
    }
    
    func deselect(){
        backgroundColor = UIColor.whiteColor()
        timeLabel.textColor = UIColor(hexString: "3D4247")
        votesLabel.textColor = UIColor(hexString: "3D4247")
        votesLabel.alpha = 0.2
        timeLabel.alpha = 0.2
    }
    
}