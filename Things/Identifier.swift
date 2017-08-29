//
//  ThingID.swift
//  Things
//
//  Created by Brie Heutmaker on 5/18/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import Foundation

protocol Named {
    var name: String! { get set }
}

protocol Identified: Named, Dated {
    var id: String? { get set }
}

struct Identifier: Equatable, Dated {

    var string: String
    
    var created: String?
    var updated: String?
    
    init(string: String) {
        self.string = string
    }
    
    init(int: Int) {
        self.string = "\(int)"
    }
    
    ///Creates a new Identifier and assigns 'UUID.init().uuidString' to self's string variable.
    init() {
        let uuid = UUID.init().uuidString
        string = uuid
        
        created = Date().string
    }
}

func == (lhs: Identifier, rhs: Identifier) -> Bool {
    
    let stringsMatch = lhs.string == rhs.string
    let dateCreatedMatches = lhs.created == rhs.created
    
    return stringsMatch && dateCreatedMatches
}
