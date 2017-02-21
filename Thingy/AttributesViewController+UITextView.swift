//
//  AttributesViewController+UITextView.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 7/25/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import UIKit

extension AttributesViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        setBarButtonItems(.done(backButtonHidden: true))
        
        activeTextView = textView
        oldText = activeTextView!.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
        oldText = nil
        
        setBarButtonItems(.thingButtons)
    }
}
