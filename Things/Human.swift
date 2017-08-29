//
//  Human.swift
//  Things
//
//  Created by Brianna Lee on 5/10/16.
//  Copyright © 2016 Brianna Lee. All rights reserved.
//

import UIKit

struct Human: Identified {
    
    ///The singleton user object that represents the currently logged in user
    static var currentUser: Human? = {
        
        if Human.currentUser == nil {
            
        }
        
        return nil
    }()

    //MARK: Protocol: Identified
    var id: String!
    var name: String!
    
    var created: String?
    var updated: String?
    
    init(id: String) {
        self.id = id
        self.name = ""
    }
}
