//
//  MyGroupsViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 1/25/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import UIKit
import Firebase

class MyGroupsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Instance Variables
    
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var createButton: UIBarButtonItem = UIBarButtonItem()
    private var groups = [Group]()
    private var membershipChangedHandle = FirebaseHandle()
    private var membershipAddedHandle = FirebaseHandle()
    private var membershipRemovedHandle = FirebaseHandle()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view controllers background color
        view.backgroundColor = Constants.Color.lightGreyBackground
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Groups"
        
        // Add create button
        createButton = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "create")
        navigationItem.setRightBarButtonItem(createButton, animated: false)
        
        // CollectionViewFlowLayout
        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        let cellwidth = (view.frame.size.width - 30) / 2
        layout.itemSize = CGSizeMake(cellwidth, 60)
        
        // UICollectionView
        let frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, (self.view.frame.size.height - tabBarController!.tabBar.frame.size.height))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.registerNib(UINib(nibName: "GroupCell", bundle: nil), forCellWithReuseIdentifier: "GroupCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Constants.Color.lightGreyBackground
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        self.view.addSubview(collectionView)
        
        beginListening()
    }
    
    func beginListening(){
        let myId = Database.BASE_REF.authData.uid
        let myMembershipsRef = Database.MEMBERSHIP_REF.childByAppendingPath(myId)
        
        let alertController = UIAlertController(title: myId, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        membershipAddedHandle = myMembershipsRef.observeEventType(.ChildAdded, withBlock:{ snapshot in
            let key = snapshot.key
            Database.groupFromKey(key) { group in
                self.groups.append(group)
                self.collectionView.reloadData()
            }
        })
        
        membershipChangedHandle = myMembershipsRef.observeEventType(.ChildChanged, withBlock:{ snapshot in
            let key = snapshot.key
            Database.groupFromKey(key) { group in
                self.groups = self.groups.filter({ $0.key != group.key })
                self.groups.append(group)
                self.collectionView.reloadData()
            }
        })
        
        membershipRemovedHandle = myMembershipsRef.observeEventType(.ChildRemoved, withBlock:{ snapshot in
            let key = snapshot.key
            Database.groupFromKey(key) { group in
                self.groups = self.groups.filter({ $0.key != group.key })
                self.collectionView.reloadData()
            }
        })
    }
    
    func create(){
        let createGroupNavigationController = UINavigationController(rootViewController: CreateGroupViewController())
        presentViewController(createGroupNavigationController, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewControllerDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GroupCell", forIndexPath: indexPath) as! GroupCell
        cell.configureCell(groups[indexPath.row])
        
        return cell
    }
    
    // MARK: UICollectionViewControllerDelegate
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GroupCell
        cell.backgroundColor = UIColor(hexString: "EFF3F5")
        
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GroupCell
        cell.backgroundColor = UIColor.whiteColor()
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedGroup = groups[indexPath.row]
        
        let gvc = GroupViewController(group: selectedGroup)
        print(navigationController)
        navigationController?.pushViewController(gvc, animated: true)
        
    }
    
    
}