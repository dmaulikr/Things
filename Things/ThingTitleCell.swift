//
//  ThingTitleCell.swift
//  Things
//
//  Created by Brianna Lee on 4/18/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import UIKit

class ThingTitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
}
