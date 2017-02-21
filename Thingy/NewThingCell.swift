//
//  NewThingCell.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 11/18/15.
//  Copyright © 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class NewThingCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var newThingTextField: UITextField!
    
    var delegate: NewThingCellDelegate!
    
    override func prepareForReuse() {
        newThingTextField.text = ""
    }
    
    @IBAction func save() {
        
        if let newText = newThingTextField.text {
            
            if newText != "" {
                let thing: Thing = Thing(name: newText)
                
                Coordinator.default.save(thing, closure: { (_thing) in
                    self.delegate.didSave(new: _thing)
                    
                }, errorBlock: { e in
                    print("Thing failed to save :(", "(\(e?.localizedDescription ?? "(No error found)"))")
                })
                
            } else {
                
                newThingTextField.placeholder = "Nothing here..."
                
                delay(1.5, {
                    self.newThingTextField.placeholder = "New thing..."
                })
                
                return
            }
        }
    }
    
    @IBAction func cancel() {
        reset() {
            self.delegate.didCancelNewThing()
        }
    }
    
    private func reset(_ block: @escaping Block) {
        newThingTextField.text = ""
        block()
    }
}

protocol NewThingCellDelegate {
    func didCancelNewThing()
    func didSave(new thing: Thing)
}
