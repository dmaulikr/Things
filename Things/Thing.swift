//
//  Thing.swift
//  Things
//
//  Created by Brie Heutmaker on 11/18/15.
//  Copyright © 2015 Brie Heutmaker. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Thing: NSObject, Objectified {
    
    var owner: String?
    
    var icon: String?
    var attributes: [Attribute] = []
    
    var objectType: ObjectType = .thing
    var id: String!
    var name: String!
    
    var created: String?
    var updated: String?
    
    func dict() -> [String : Any] {
        var _dict: [String : Any] = [:]
        
        _dict["id"] = self.id
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
        
        if let _owner = dict["owner"] as? String {
            self.owner = _owner
        }
        
        if let _icon = dict["icon"] as? String {
            self.icon = _icon
        }
        
        if let _objectTypeHash = dict["objectType"] as? Int {
            if let _objectType = ObjectType(rawValue: _objectTypeHash) {
                self.objectType = _objectType
            }
        }
        
        if let _id = dict["id"] as? String {
            self.id = _id
        }
        
        if let _name = dict["name"] as? String {
            self.name = _name
        }
        
//        print(dict)
        
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
    
    override required init() {
        super.init()
        id = newID()
    }
    
    required init(from object: Object) {
        super.init()
        objectType = object.objectType
        if object.id == "" {
            id = newID()
        } else {
            id = object.id
        }
        name = object.name
        self.icon = randomFontAwesomeCode()
    }
    
    ///Creates new Thing instance assigning the 'name' parameter to self.name. A new UUID is generated and assigned to self.id. This initialization is meant to be used to create a new Attribute object prior to saving it to the server, generally when the user initiates creating a new Thing from the UI.
    init(name: String) {
        super.init()
        self.name = name
        self.id = newID()
        if self.icon == nil {
            self.icon = randomFontAwesomeCode()
        }
    }
    
    private func newID() -> String {
        return Database.database().reference(withPath: "/humans/\(AppState.shared.uid!)/things/").childByAutoId().key
    }
}
