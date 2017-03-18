//
//  AttributeTextCell.swift
//  Things
//
//  Created by Brie Heutmaker on 4/20/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import UIKit

class AttributeTextCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var newAttributeTextView: UITextView!
    @IBOutlet weak var thingDescriptionLabel: UILabel!
    
    override func prepareForReuse() {
        newAttributeTextView.text = ""
    }
}
