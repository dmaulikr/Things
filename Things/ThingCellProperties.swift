//
//  ThingCellProperties.swift
//  Things
//
//  Created by Brianna Lee on 8/15/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
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
