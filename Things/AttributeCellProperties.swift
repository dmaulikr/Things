//
//  AttributeCellProperties.swift
//  Things
//
//  Created by Brie Heutmaker on 3/18/17.
//  Copyright © 2017 Exoteric Design. All rights reserved.
//

import Foundation

enum AttributeCellProperties {
    case save
    case failSave
    case failDelete
    case header
    case attributeImage
    case attributeText
    case badCell
    
    var identifier: String {
        switch self {
            
        case .save:             return CellKey.save
        case .failSave:         return CellKey.failSave
        case .failDelete:       return CellKey.failDelete
        case .header:           return CellKey.header
        case .attributeImage:   return CellKey.attributeImage
        case .attributeText:    return CellKey.attributeText
            
        default:
            return CellKey.badCell
        }
    }
}
