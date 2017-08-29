//
//  Attribute.swift
//  Things
//
//  Created by Brie Heutmaker on 4/18/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum AttributeType: Int {
    case text
    case image
}

protocol Attribute: Objectified {
    var type: AttributeType { get }
    var parent: String! { get }
    
    func dict() -> [String : Any]
    
    init(from dict: [String : Any])
}

extension Attribute {
    func ref() -> DatabaseReference {
        print(parent)
        return Database.database().reference(withPath: "/humans/\(AppState.shared.uid!)/things/\(parent)/attributes/\(id)")
    }
    
    func newID() -> String {
        return ref().childByAutoId().key
    }
}
