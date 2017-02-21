//
//  AppState.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 1/13/17.
//  Copyright © 2017 Ben Heutmaker. All rights reserved.
//

import Foundation

class AppState {
    
    static let shared = AppState()
    
    var signedIn = false
    
    private static let accessTokenKey = "accessKey"
    private static let refreshTokenKey = "refreshToken"
    private static let usernameKey = "username"
    
    var username: String? {
        get { return UserDefaults.standard.string(forKey: "username") }
        set { UserDefaults.standard.set(newValue, forKey: AppState.usernameKey) }
    }
    
    var accessToken: String? {
        get { return UserDefaults.standard.string(forKey: AppState.accessTokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: AppState.accessTokenKey) }
    }
    
    var refreshToken: String? {
        get { return UserDefaults.standard.string(forKey: AppState.refreshTokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: AppState.refreshTokenKey) }
    }
    
}
