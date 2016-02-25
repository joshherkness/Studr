//
//  VotingViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 2/24/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import UIKit
import DGRunkeeperSwitch
import Firebase

class VotingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Instance Variables
    
    var collectionView: UICollectionView!
    var selectedDates = [NSDate]()
    var group: Group!
    var myGroupVotesRef: Firebase!
    
    // MARK: Initializers
    
    init(group: Group){
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view controllers background color
        view.backgroundColor = Color.lightGreyBackground
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true
        navigationItem.title = "Voting"
        
        // Mode Switch
        let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Simple", rightTitle: "Advanced")
        runkeeperSwitch.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.titleColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = Color.primary
        runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        runkeeperSwitch.addTarget(self, action: Selector("changeMode"), forControlEvents: .ValueChanged)
        navigationItem.titleView = runkeeperSwitch
        
        // Add done button
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.leftBarButtonItem = button
        
        // CollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4)
        let cellwidth = (view.frame.size.width - 32) / 7
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSizeMake(cellwidth, cellwidth)
        
        // CollectionView
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.registerClass(TimeVoteCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = view.backgroundColor
        collectionView.delaysContentTouches = false
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        if let authData = Database.BASE_REF.authData {
            myGroupVotesRef = Database.VOTES_REF.childByAppendingPath(authData.uid)
            myGroupVotesRef?.keepSynced(true)
        }
        
        view.updateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        collectionView.snp_makeConstraints(closure: { make in
            make.top.bottom.right.left.equalTo(self.view)
        })
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 168
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TimeVoteCell
        cell.configureCell(2, date: NSDate())
        
        let selectedItems = collectionView.indexPathsForSelectedItems()
        if let selectedItems = selectedItems {
            if selectedItems.contains(indexPath) {
                cell.select()
            }else{
                cell.deselect()
            }
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TimeVoteCell
        cell.select()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TimeVoteCell
        cell.deselect()
    }
    
    // MARK: Firebase
    
    func selectTime(){
    }
    
    func deselectTime(){
    }
    
    // MARK: Selectors
    
    func changeMode(){
        
    }
    
    func tappedDone(sender: UIButton){
        // Return to the previous view controller
        self.navigationController?.popViewControllerAnimated(true)
    }
}