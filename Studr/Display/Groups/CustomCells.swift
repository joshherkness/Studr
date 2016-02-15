//
//  CustomCells.swift
//  Studr
//
//  Created by Joshua Herkness on 11/15/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import Eureka

/*
public class PFUserMultipleSelectorCell: PushSelectorCell<Set<PFUser>> {
    
    var vPadding: CGFloat = 5.0
    var hPadding: CGFloat = 5.0
    var spacing: CGFloat  = 10.0
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    public override func setup() { super.setup() }
    
    public override func update() {
        super.update()
        
        // Convert the members set to an array
        let membersSet = self.row.value
        var members:[PFUser] = []
        for var member:PFUser in membersSet!{
            members.append(member)
        }
        // Calculate frame values
        let contentViewWidth:CGFloat = self.contentView.frame.size.width
        let contentViewHeight:CGFloat = self.contentView.frame.size.height
        let imageWidth:CGFloat = contentViewHeight  - spacing
        let imageHeight:CGFloat = imageWidth
        
        let maxMembersDisplayed:Int = Int(floor(contentViewWidth / ( hPadding + imageWidth)))
        let membersDisplayed = members.count <= maxMembersDisplayed ? members.count : maxMembersDisplayed
        let membersNotDisplayed = members.count <= maxMembersDisplayed ? 0 : members.count - maxMembersDisplayed
        
        // Creates the members profiles
        for var i = 0; i < membersDisplayed; i++ {
            // Member at index of dataset
            let member:PFUser = members[i]
            
            // Create label
            let frame: CGRect = CGRect(x: hPadding*(CGFloat(i+1)) + imageWidth*(CGFloat(i)), y: vPadding, width: imageWidth, height: imageHeight)
            let label = UILabel(frame: frame)
            label.backgroundColor = STColor.red()
            label.text = member.valueForKey("username") as? String ?? "Hello"
            self.contentView.addSubview(label)
        }
        
        // Creates aditional members notification
        if membersNotDisplayed > 0 {
            
            // Create notification label
            let frame: CGRect = CGRect(x: hPadding*(CGFloat(membersDisplayed+1)) + imageWidth*(CGFloat(membersDisplayed)), y: vPadding, width: imageWidth, height: imageHeight)
            let label = UILabel(frame: frame)
            label.text = "\(membersNotDisplayed)"
            self.contentView.addSubview(label)
        }
    }
}
*/

/*
public class PFUserMultipleSelectorRow: GenericMultipleSelectorRow<PFUser, MultipleSelectorViewController<PFUser>> {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        self.displayValueFor = {
            if let t = $0 {
                return t.count > 0 ? "\(t.count)" : "I'm Lonely"
            }
            return nil
        }

    }
}
*/

public final class MembersSelectorRow : SelectorRow<Set<String>, AddMembersTableViewController >, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return AddMembersTableViewController(){ _ in } }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
        self.displayValueFor = {
            if let t = $0 {
                return t.count == 1 ? "\(t.count) member" : "\(t.count) members"
            }
            return nil
        }
    }
}

/*

public class MultipleMemberSelectorRow<T: Hashable, VCType: TypedRowControllerType where VCType: UIViewController,  VCType.RowValue == Set<T>>: Row<Set<T>, PushSelectorCell<Set<T>>>, PresenterRowType {
    
    /// Defines how the view controller will be presented, pushed, etc.
    public var presentationMode: PresentationMode<VCType>?
    
    /// Will be called before the presentation occurs.
    public var onPresentCallback : ((FormViewController, VCType)->())?
    
    /// Title to be displayed for the options
    public var selectorTitle: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback { return VCType() }, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) })
    }
    
    public required convenience init(_ tag: String, @noescape _ initializer: (MultipleMemberSelectorRow<T, VCType> -> ()) = { _ in }) {
        self.init(tag:tag)
        RowDefaults.rowInitialization["\(self.dynamicType)"]?(self)
        initializer(self)
    }
    
    /**
     Extends `didSelect` method
     */
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.createController(){
                    controller.row = self
                    if let title = selectorTitle {
                        controller.title = title
                    }
                    onPresentCallback?(cell.formViewController()!, controller)
                    presentationMode.presentViewController(controller, row: self, presentingViewController: self.cell.formViewController()!)
                }
                else{
                    presentationMode.presentViewController(nil, row: self, presentingViewController: self.cell.formViewController()!)
                }
            }
        }
    }
    
    /**
     Prepares the pushed row setting its title and completion callback.
     */
    public override func prepareForSegue(segue: UIStoryboardSegue) {
        super.prepareForSegue(segue)
        guard let rowVC = segue.destinationViewController as? VCType else {
            return
        }
        if let title = selectorTitle {
            rowVC.title = title
        }
        if let callback = self.presentationMode?.completionHandler{
            rowVC.completionCallback = callback
        }
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
        
    }
}
*/