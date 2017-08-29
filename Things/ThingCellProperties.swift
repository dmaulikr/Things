//
//  ThingCellProperties.swift
//  Things
//
//  Created by Brie Heutmaker on 8/15/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import Foundation

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
