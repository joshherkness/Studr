//
//  OnboardingViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/10/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // MARK: Outlets
    
    @IBOutlet weak var signUpBtn: RoundedButton!
    @IBOutlet weak var signInBtn: RoundedButton!
    
    // MARK: Instance Variables
    
    var pageViewController : UIPageViewController!
    var pageTitles : [String]!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Change the background color
        view.backgroundColor = UIColor(hexString: "#0A4162")
        
        // Change colors
        signUpBtn.backgroundColor = UIColor.whiteColor()
        signUpBtn.tintColor = UIColor(hexString: "#0A4162")
        
        signInBtn.backgroundColor = UIColor(hexString: "#205373")
        signInBtn.tintColor = UIColor(hexString: "#0A4162")
        
        // Declare page titles
        pageTitles = ["Page 1", "Page 2", "Page 3"]
        
        //Instantiate the PageViewController and add it to the OnboardingViewController
        pageViewController =  storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        pageViewController!.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as ContentViewController
        
        let viewControllers = [startVC]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height - 80)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        
        // Change the appearance of the UIPageControl
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func viewControllerAtIndex(index:Int) -> ContentViewController{
        if(self.pageTitles.count == 0 || index >= self.pageTitles.count){
            return ContentViewController()
        }
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        vc.titleText = self.pageTitles[index]
        vc.pageIndex = index
        
        return vc
    }
    
    //MARK: UIPageViewController Datasource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound){
            return nil
        }
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound){
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: Actions

    @IBAction func unwindToOnboarding(unwindSegue: UIStoryboardSegue) {}
}
