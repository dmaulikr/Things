//
//  IconCell.swift
//  Things
//
//  Created by Brianna Lee on 3/19/17.
//  Copyright © 2017 Exoteric Design. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    @IBOutlet var iconImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundColor = .white
    }
}
