//
//  NewObject.swift
//  Things
//
//  Created by Brie Heutmaker on 8/14/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import Foundation

class Object: Objectified {
    
    var created: String?
    var updated: String?
    
    var objectType: ObjectType
    var id: String!
    var name: String!
    
    init(type: ObjectType) {
        self.objectType = type
    }
    
    required init(from object: Object) {
        objectType = object.objectType
        id = object.id
        name = object.name
    }
}

protocol Objectified: Identified {
    var objectType: ObjectType { get set }
    init(from object: Object)
}

enum ObjectType: Int {
    
    case new
    
    case thing, attribute
    
    case save
    case failSave, failDelete
    
    var isNew: Bool {
        return self == .new
    }
    
    var string: String {
        switch self {
        case .attribute:
            return "Attribute"
            
        case .thing:
            return "Thing"
            
        case .save:
            return "Saved successfully ❤️"
            
        case .failSave:
            return "Failed to save! 🙈"
            
        case .failDelete:
            return "Failed to delete! 👎🏼"
            
        default:
            return ""
        }
    }
}
