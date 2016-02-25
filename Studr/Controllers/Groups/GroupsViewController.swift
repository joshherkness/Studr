//
//  MyGroupsViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 1/25/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import UIKit
import Firebase

class GroupsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Instance Variables
    
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var createButton: UIBarButtonItem = UIBarButtonItem()
    private var groups = [Group]()
    private var myMembershipsRef: Firebase?
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view controllers background color
        view.backgroundColor = Color.lightGreyBackground
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true
        navigationItem.title = "Groups"
        
        // Add create button
        createButton = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "create")
        navigationItem.setRightBarButtonItem(createButton, animated: false)
        
        // CollectionViewFlowLayout
        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        let cellwidth = (view.frame.size.width - 30) / 2
        layout.itemSize = CGSizeMake(cellwidth, cellwidth  * 1.1)
        
        // UICollectionView
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.registerClass(GroupCell.self, forCellWithReuseIdentifier: "GroupCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Color.lightGreyBackground
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        self.view.addSubview(collectionView)
        
        // Firebase
        if let authData = Database.BASE_REF.authData {
            myMembershipsRef = Database.MEMBERSHIP_REF.childByAppendingPath(authData.uid)
            myMembershipsRef?.keepSynced(true)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        beginObserving()
    }
    
    override func viewDidDisappear(animated: Bool) {
        myMembershipsRef?.removeAllObservers()
    }
    
    // MARK: Firebase
    
    func beginObserving(){
        groups.removeAll()
        
        myMembershipsRef?.observeEventType(.ChildAdded, withBlock:{ snapshot in
            let key = snapshot.key
            Database.getGroup(key) { group in
                self.groups.append(group)
                self.collectionView.reloadData()
            }
        })
        
        myMembershipsRef?.observeEventType(.ChildChanged, withBlock:{ snapshot in
            let key = snapshot.key
            Database.getGroup(key) { group in
                self.groups = self.groups.filter({ $0.key != group.key })
                self.groups.append(group)
                self.collectionView.reloadData()
            }
        })
        
        myMembershipsRef?.observeEventType(.ChildRemoved, withBlock:{ snapshot in
            let key = snapshot.key
            self.groups = self.groups.filter({ $0.key != key })
            self.collectionView.reloadData()
        })
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
        cell.backgroundColor = UIColor(hexString: "F4F5F6")
        
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GroupCell
        cell.backgroundColor = UIColor.whiteColor()
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedGroup = groups[indexPath.row]
        
        let gvc = GroupViewController(group: selectedGroup)
        navigationController?.pushViewController(gvc, animated: true)
        
    }
    
    // MARK: Selectors
    
    func create(){
        let createGroupNavigationController = UINavigationController(rootViewController: CreateGroupViewController())
        presentViewController(createGroupNavigationController, animated: true, completion: nil)
    }
    
}