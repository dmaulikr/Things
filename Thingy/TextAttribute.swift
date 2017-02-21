//
//  TextAttribute.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 8/14/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import Foundation

protocol TextManager {
    var text: String! { get set }
}

struct TextAttribute: Attribute, TextManager {
    
    //MARK: protocol TextManager
    var text: String!
    
    //MARK: protocol Attribute
    var type: AttributeType = .text
    var parent: String
    
    var id: String = ""
    
    var objectType: ObjectType = .attribute
    
    var name: String = ""
    
    var dateModified: Date?
    var dateCreated: Date?
    
    internal func dict() -> [String : Any] {
        var _dict: [String : Any] = [:]
        
        _dict["text"] = self.text
        _dict["type"] = type.hashValue
        _dict["parent"] = self.parent
        
        return _dict
    }
    
    init(text: String, parent: Thing) {
        self.text = text
        self.parent = parent.id
    }
    
    init(from object: Object) {
        id = object.id
        objectType = object.objectType
        self.parent = ""
    }
    
    init(from dict: [String : Any]) {
        if let _text = dict["text"] as? String {
            self.text = _text
        }
        
        if let _typeHash = dict["type"] as? Int {
            guard let _type = AttributeType(rawValue: _typeHash) else {
                fatalError()
            }
            
            self.type = _type
        }
        
        self.objectType = .attribute
        self.id = dict["id"] as! String
        self.parent = dict["parent"] as! String
    }
}
