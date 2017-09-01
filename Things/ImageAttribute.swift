//
//  ImageAttribute.swift
//  Things
//
//  Created by Brianna Lee on 8/14/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import UIKit

class ImageAttribute: Attribute, ImageManager {
    
    ///Initialize with NewObject. Note that when this is initialized a new UUID is generated and assigned to the Identifier. This initialization is meant to be used to create a new Attribute object prior to saving it to the server, generally when the user initiates creating a new Attribute from the UI.
    required init(from object: Object) {
        name = object.name
        self.parent = ""
        id = newID()
    }
    
    init(image: UIImage, parent: Thing) {
        self.image = image
        self.parent = parent.id
        id = newID()
    }
    
    required init(from dict: [String : Any]) {
        self.parent = ""
        id = newID()
    }
    
    //MARK: protocol ImageManager
    var image: UIImage!
    
    //MARK: protocol Attribute
    var type: AttributeType = .image
    
    var objectType: ObjectType = .attribute
    
    var parent: String!
    
    var id: String?
    var name: String!
    
    var created: String?
    var updated: String?
    
    internal func dict() -> [String : Any] {
        var _dict: [String : Any] = [:]
        
        print("Image Attribute dict() -> [String : Any] has not been set.")
        _dict["id"] = self.id
        
        return _dict
    }
}

protocol ImageManager {
    var image: UIImage! { get }
}

extension ImageManager {
    
    func imageHeight(from newWidth: CGFloat) -> CGFloat? {
        
        let originalHeight = image.size.height
        let originalWidth = image.size.width
        
        let newHeight = originalHeight / originalWidth * newWidth
        
        return newHeight + 20
    }
}
