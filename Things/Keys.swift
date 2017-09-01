//
//  Keys.swift
//  Things
//
//  Created by Brianna Lee on 8/15/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import Foundation

struct SegueKey {
    static let showDetail = "showDetail"
    static let imageSegue = "imageSegue"
}

struct CellKey {
    static let save = "saveCell"
    static let failSave = "failSaveCell"
    static let failDelete = "failDeleteCell"
    
    static let header = "headerCell"
    
    static let attributeImage = "attributeImageCell"
    static let attributeText = "attributeTextCell"
    
    static let thing = "thingCell"
    static let newThing = "newThingCell"
    
    static let badCell = "badCell"
}

struct UserKey {
    static let user = "user"
    static let name = "name"
}

struct ThingKey {
    static let type = "thing"
    static let name = "name"
    static let icon = "icon"
    static let record = "record"
    static let attributes = "attributes"
}

struct AttributeKey {
    static let type = "attribute"
    static let parent = "parent"
    static let attributes = "attributes"
    static let image = "image"
    static let text = "text"
}

struct NotificationKeys {
    static let SignedIn = "onSignInCompleted"
}

struct Segues {
    static let LoginSegue = "LoginSegue"
    static let FpToSignIn = "FPToSignIn"
}

struct MessageFields {
    static let name = "name"
    static let text = "text"
    static let photoURL = "photoURL"
    static let imageURL = "imageURL"
}
