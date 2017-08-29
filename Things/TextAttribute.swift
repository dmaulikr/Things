//
//  TextAttribute.swift
//  Things
//
//  Created by Brie Heutmaker on 8/14/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import Foundation

protocol TextManager {
    var text: String { get set }
}

class TextAttribute: Attribute, TextManager {
    
    //MARK: protocol TextManager
    var text: String
    
    //MARK: protocol Attribute
    var type: AttributeType = .text
    var parent: String!
    
    var id: String?
    
    var objectType: ObjectType = .attribute
    
    var name: String!
    
    var created: String?
    var updated: String?
    
    internal func dict() -> [String : Any] {
        var _dict: [String : Any] = [:]
        
        _dict["text"] = self.text
        _dict["type"] = type.hashValue
        _dict["parent"] = self.parent
        _dict["created"] = self.created
        _dict["updated"] = self.updated
        _dict["id"] = self.id
        
        return _dict
    }
    
    init(text: String, parent: Thing) {
        self.text = text
        self.parent = parent.id
        self.created = Date().string
        self.updated = Date().string
        
        self.id = newID()
    }
    
    required init(from object: Object) {
        text = ""
        id = newID()
        objectType = object.objectType
    }
    
    required init(from dict: [String : Any]) {
        if let _text = dict["text"] as? String {
            self.text = _text
        } else {
            self.text = "Error"
        }
        
        if let _typeHash = dict["type"] as? Int {
            guard let _type = AttributeType(rawValue: _typeHash) else {
                fatalError()
            }
            
            self.type = _type
        }
        
//        print(dict)
        
        self.created = dict["created"] as? String
        self.updated = dict["updated"] as? String
        
        self.objectType = .attribute
        self.id = dict["id"] as? String
        self.parent = dict["parent"] as! String
    }
}
