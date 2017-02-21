//
//  Attribute.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 4/18/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import UIKit

enum AttributeType: Int {
    case text
    case image
}

protocol Attribute: Objectified {
    var type: AttributeType { get }
    var parent: String { get }
    
    func dict() -> [String : Any]
    
    init(from dict: [String : Any])
}
