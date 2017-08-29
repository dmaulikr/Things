//
//  AttributeHelper.swift
//  Things
//
//  Created by Brie Heutmaker on 2/16/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
//

import Foundation

struct AttributeFactory {
    
    static var shared = AttributeFactory()
    
    public func generateAttribute(from dict: [String : Any]) -> Attribute? {
        
        var _type: AttributeType?
        
        _type = findAttributeType(in: dict)
        var _dict = dict
        
        if _type == nil {
            guard let attributeDict = dict["attribute"] as? [String:Any] else { fatalError() }
            _type = findAttributeType(in: attributeDict)
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
    
    private func findAttributeType(in dict: [String : Any]) -> AttributeType {
        
        print(dict)
        
        guard
            let typeHash = dict["type"] as? Int,
            let type = AttributeType(rawValue: typeHash)
            else {
                fatalError()
        }
        
        return type
    }
}
