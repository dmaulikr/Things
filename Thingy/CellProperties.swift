//
//  CellProperties.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 8/15/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import Foundation

enum AttributeCellProperties {
    case save
    case failSave
    case failDelete
    case header
    case attributeImage
    case attributeText
    
    var identifier: String {
        switch self {
            
        case .save:             return CellKey.save
        case .failSave:         return CellKey.failSave
        case .failDelete:       return CellKey.failDelete
        case .header:           return CellKey.header
        case .attributeImage:   return CellKey.attributeImage
        case .attributeText:    return CellKey.attributeText
        }
    }
}

enum ThingCellProperties {
    case thing
    case newThing
    case badCell
    
    var identifier: String {
        switch self {
            
        case .thing:            return CellKey.thing
        case .newThing:         return CellKey.newThing
            
        default:
            return CellKey.badCell
        }
    }
}
