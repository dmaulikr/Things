//
//  User.swift
//  Things
//
//  Created by Brie Heutmaker on 5/10/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
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
    
    var created: String?
    var updated: String?
    
    init(id: String) {
        self.id = id
        self.name = ""
    }
}
