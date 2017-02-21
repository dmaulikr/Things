//
//  AttributeTextCell.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 4/20/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import UIKit

class AttributeTextCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var newAttributeTextView: UITextView!
    @IBOutlet weak var thingDescriptionLabel: UILabel!
    
    override func prepareForReuse() {
        newAttributeTextView.text = ""
    }
}
