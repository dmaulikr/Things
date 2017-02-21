//
//  User.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 5/10/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import UIKit

struct Thinger: Identified {
    
    ///The singleton user object that represents the currently logged in user
    static var currentUser: Thinger? = {
        
        if Thinger.currentUser == nil {
            
        }
        
        return nil
    }()

    //MARK: Protocol: Identified
    var id: String
    var name: String
    
    var dateModified: Date?
    var dateCreated: Date?
    
    init(id: String) {
        self.id = id
        self.name = ""
    }
}
