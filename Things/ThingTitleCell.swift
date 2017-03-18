//
//  ThingTitleCell.swift
//  Things
//
//  Created by Brie Heutmaker on 4/18/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import UIKit

class ThingTitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
}
