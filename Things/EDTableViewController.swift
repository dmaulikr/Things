//
//  EDTableViewController.swift
//  Things
//
//  Created by brie on 8/28/17.
//  Copyright © 2017 Exoteric Design. All rights reserved.
//

import UIKit

enum EDTableViewControllerType {
    case things
    case attributes
}

class EDTableViewController: UIViewController {
    
    var type: EDTableViewControllerType!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        registerForKeyboardNotifications()
        super.viewDidLoad()
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    fileprivate func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(EDTableViewController.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    fileprivate func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc fileprivate func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if endFrame?.origin.y ?? 0.0 >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                guard let height = endFrame?.size.height else {
                    self.keyboardHeightLayoutConstraint?.constant = 0.0
                    return
                }
                
                self.keyboardHeightLayoutConstraint?.constant = height
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve,
                           
                           animations: {
                            self.view.layoutIfNeeded()
            },
                           
                           completion: { bool in
//                            let position: UITableViewScrollPosition = .none
//                            switch self.type! {
//                            case .attributes:
//                                position = .bottom
//                            case .things:
//                                position = .top
//                            }
//                            self.scrollToRow(at: position, then: {})
            })
        }
    }
    
    func scrollToRow(at position: UITableViewScrollPosition, then completion: @escaping (()->())) {
        
        UIView.animate(withDuration: 0.3, animations: {
            var cellOffset: CGPoint!
            
            switch position {
            case .bottom:
                cellOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height)
                
            case .top:
                cellOffset = CGPoint(x: 0, y: 0)
                
            case .middle:
                cellOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - (self.tableView.bounds.size.height / 2))
                
            case .none:
                cellOffset = CGPoint(x: 0, y: 0)
            }
            
            self.tableView.setContentOffset(cellOffset, animated: false)
            
        }) { (finished) in
            completion()
        }
    }
}
