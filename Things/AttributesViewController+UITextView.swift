//
//  AttributesViewController+UITextView.swift
//  Things
//
//  Created by Brie Heutmaker on 7/25/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import UIKit

extension AttributesViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let indexPath = activeTextViewIndexPath else { return }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        setBarButtonItems(.done(backButtonHidden: true))
        
        activeTextView = textView
        oldText = activeTextView!.text
        
//        tableView.isScrollEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
        oldText = nil
        
        setBarButtonItems(.thingButtons)
        
//        tableView.isScrollEnabled = true
    }
}
