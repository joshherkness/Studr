//
//  ProfileImageCollectionView.swift
//  Studr
//
//  Created by Joseph Herkness on 2/24/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileImageCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate{
    
    // MARK: Instance Variables
    
    var users = [User]()
    
    // MARK: UICollectionView
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        backgroundColor = UIColor.clearColor()
        alwaysBounceVertical = false
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        dataSource = self
        delegate = self
        registerClass(ProfileImageCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let user = users[indexPath.row]
        
        let cell = dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProfileImageCell
        cell.configureCell(user)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
}

class ProfileImageCell: UICollectionViewCell {
    
    var profileImageView: RoundedImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = UIColor.clearColor()
        
        profileImageView = RoundedImageView()
        addSubview(profileImageView)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        profileImageView.snp_makeConstraints(closure: {make in
            make.right.top.left.bottom.equalTo(self)
        })
        
        super.updateConstraints()
    }
    
    func configureCell(user: User){
        getProfileImageForUser(user.uid, email: user.email, onSuccess: { image in
            self.profileImageView.image = image
        })
    }
}