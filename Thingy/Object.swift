//
//  NewObject.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 8/14/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import Foundation

struct Object: Objectified {
    
    var dateCreated: Date?
    var dateModified: Date?
    
    var objectType: ObjectType
    var id: String = ""
    var name: String = ""
    
    init(type: ObjectType) {
        self.objectType = type
    }
    
    init(from object: Object) {
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
