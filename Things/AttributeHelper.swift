//
//  AttributeHelper.swift
//  Things
//
//  Created by Brie Heutmaker on 2/16/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
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
        var _type: AttributeType?
        
        _type = AttributeHelper.findAttributeType(from: dict)
        var _dict = dict
        
        if _type == nil {
            guard let attributeDict = dict["attribute"] as? [String:Any] else { fatalError() }
            _type = AttributeHelper.findAttributeType(from: attributeDict)
            _dict = attributeDict
        }
        
        var attribute: Attribute!
        
        guard let type = _type else { fatalError() }
        
        switch type {
        case .image:
            attribute = ImageAttribute(from: _dict)
        case .text:
            attribute = TextAttribute(from: _dict)
        }
        
        return attribute
    }
}
