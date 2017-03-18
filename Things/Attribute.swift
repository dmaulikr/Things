//
//  Attribute.swift
//  Things
//
//  Created by Brie Heutmaker on 4/18/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
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
