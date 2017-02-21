//
//  AttributeHelper.swift
//  Things
//
//  Created by Benjamin Heutmaker on 2/16/17.
//  Copyright © 2017 Ben Heutmaker. All rights reserved.
//

import Foundation

struct AttributeHelper {
    
    static func findAttributeType(from dict: [String : Any]) -> AttributeType? {
        if let _typeValue = dict["type"] as? String {
            guard let _typeHash = Int(_typeValue) else { fatalError() }
            guard let _type = AttributeType(rawValue: _typeHash) else { fatalError() }
            
            return _type
        }
        
        return nil
    }
    
    static func attribute(from dict: [String : Any]) -> Attribute? {
        guard let type = AttributeHelper.findAttributeType(from: dict) else {
            return nil
        }
        
        var attribute: Attribute!
        
        switch type {
            
        case .image:
            attribute = ImageAttribute(from: dict)
            
        case .text:
            attribute = TextAttribute(from: dict)
        }
        
        return attribute
    }
}
