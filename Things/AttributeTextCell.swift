//
//  AttributeTextCell.swift
//  Things
//
//  Created by Brianna Lee on 4/20/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import UIKit

class AttributeTextCell: UITableViewCell {

    @IBOutlet var newAttributeTextView: UITextView!
    @IBOutlet weak var thingDescriptionLabel: UILabel!
    
    override func prepareForReuse() {
        newAttributeTextView.text = ""
    }
}
