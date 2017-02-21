//
//  ThingTitleCell.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 4/18/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import UIKit

class ThingTitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
}
