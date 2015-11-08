//
//  GroupsViewController.swift
//  Studr
//
//  Created by Robin Onsay on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//
import Foundation
import UIKit
import XLForm
class GroupsViewController: XLFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sideMenuToggleAction(sender: AnyObject){
        let drawerViewController: DrawerViewController = self.view.window!.rootViewController as! DrawerViewController
        drawerViewController.setPaneState(.Open, animated: true, allowUserInterruption: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
