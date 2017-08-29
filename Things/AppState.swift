//
//  AppState.swift
//  Things
//
//  Created by Brie Heutmaker on 1/13/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
//

import Foundation
import FirebaseAuth

class AppState {
    
    static let shared = AppState()
    
    var signedIn = false {
        didSet {
            if signedIn {
                let email = Auth.auth().currentUser?.email
                let uid = Auth.auth().currentUser?.uid
                set(email, uid: uid)
            }
        }
    }
    
    var email: String?
    var uid: String?
    
    private func set(_ email: String?, uid: String?) {
        self.email = email
        self.uid = uid
    }
}
