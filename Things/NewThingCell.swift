//
//  NewThingCell.swift
//  Things
//
//  Created by Brie Heutmaker on 11/18/15.
//  Copyright © 2015 Brie Heutmaker. All rights reserved.
//

import UIKit

class NewThingCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var newThingTextField: UITextField!
    
    var delegate: NewThingCellDelegate!
    
    var coordinator: Coordinator!
    
    override func prepareForReuse() {
        newThingTextField.text = ""
    }
    
    @IBAction func save() {
        
        if let newText = newThingTextField.text {
            
            if newText != "" {
                let thing: Thing = Thing(name: newText)
                
                coordinator.save(thing, closure: { (_thing) in
                    self.delegate.didSave(new: _thing)
                    
                }, errorBlock: { e in
                    self.delegate.didFail(with: e)
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
    func didFail(with error: String)
}
