//
//  AttributesViewController+UITextView.swift
//  Things
//
//  Created by Brianna Lee on 7/25/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import UIKit

extension AttributesViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
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
        finishEditingTextAttribute()
    }
}
