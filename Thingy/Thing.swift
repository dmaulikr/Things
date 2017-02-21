//
//  Thing.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 11/18/15.
//  Copyright © 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class Thing: NSObject, Objectified {
    
    var owner: String?
    
    var icon: String!
    var attributes: [Attribute] = []
    
    var objectType: ObjectType = .thing
    var id: String = ""
    var name: String = ""
    
    var dateCreated: Date?
    var dateModified: Date?
    
    func dict() -> [String : Any] {
        var _dict: [String : Any] = [:]
        
        _dict["icon"] = self.icon
        
        var _attributes: [[String : Any]] = []
        for attribute in self.attributes {
            let attributeDict = attribute.dict
            _attributes.append(attributeDict())
        }
        _dict["attributes"] = _attributes
        
        _dict["objectType"] = self.objectType.rawValue
        
        _dict["name"] = self.name
        
        return _dict
    }
    
    init(from dict: [String : Any]) {
        
        owner = dict["owner"] as! String?
        
        self.icon = dict["icon"] as! String
        
        if let _objectTypeHash = dict["objectType"] as? Int {
            if let _objectType = ObjectType(rawValue: _objectTypeHash) {
                self.objectType = _objectType
            }
        }
        
        self.id = dict["id"] as! String
        
        self.name = dict["name"] as! String
        
        print(dict)
        
        if let _unparsedAttributes = dict["attributes"] as? [[String : Any]] {
            for _unparsedAttribute in _unparsedAttributes {
                
                guard let attributeTypeHash = _unparsedAttribute["type"] as? Int else {
                    fatalError()
                }
                
                guard let attributeType = AttributeType(rawValue: attributeTypeHash) else {
                    fatalError()
                }
                
                switch attributeType {
                case .image:
                    let _imageAttribute = ImageAttribute(from: _unparsedAttribute)
                    self.attributes.append(_imageAttribute)
                    
                case .text:
                    let _textAttribute = TextAttribute(from: _unparsedAttribute)
                    self.attributes.append(_textAttribute)
                }
            }
        }
    }
    
    override required init() { super.init() }
    
    required init(from object: Object) {
        objectType = object.objectType
        id = object.id
        name = object.name
        self.icon = randomFontAwesomeCode()
    }
    
    ///Creates new Thing instance assigning the 'name' parameter to self.name. A new UUID is generated and assigned to self.id. This initialization is meant to be used to create a new Attribute object prior to saving it to the server, generally when the user initiates creating a new Thing from the UI.
    init(name: String) {
        self.name = name
        self.icon = randomFontAwesomeCode()
    }
}
