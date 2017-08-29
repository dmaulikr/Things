 //
 //  ThingDataCoordinator.swift
 //  Things
 //
 //  Created by Brie Heutmaker on 5/18/16.
 //  Copyright © 2016 Brie Heutmaker. All rights reserved.
 //
 
 import UIKit
 import FirebaseAuth
 import FirebaseDatabase
 
 enum CoordinatorErrorType {
    case objectNil
 }
 
 struct Coordinator {
    
    func thingRef(with id: String) -> DatabaseReference {
        guard let uid = AppState.shared.uid else {
            fatalError()
        }
        
        let thingRef = Database.database().reference(withPath: "/humans/\(uid)/things/\(id)/")
        return thingRef
    }
    
    func save(_ thing: Thing,
              closure: @escaping () -> Void,
              errorBlock: @escaping (_ e: String) -> Void) {
        
        print(thing.dict())
        
        thingRef(with: thing.id).updateChildValues(thing.dict()) { (error, ref) in
            guard error == nil else {
                errorBlock(error!.localizedDescription)
                return
            }
            
            closure()
        }
    }
    
    func delete(thing: Thing,
                closure: @escaping () -> Void,
                errorBlock: @escaping (_ e: String) -> Void) {
        
        thingRef(with: thing.id).removeValue { (error, ref) in
            if error != nil {
                errorBlock(error!.localizedDescription)
            
            } else {
                closure()
            }
        }
    }
    
    func attributeRef(from attribute: Attribute) -> DatabaseReference {
        guard let uid = AppState.shared.uid else {
            fatalError()
        }
        
        let attributeRef = Database.database().reference(withPath: "/humans/\(uid)/things/\(attribute.parent!)/attributes/\(attribute.id!)/")
        return attributeRef
    }
    
    func save(_ attribute: Attribute,
              closure: @escaping () -> Void,
              errorBlock: @escaping (_ e: String) -> Void) {
        
        attributeRef(from: attribute).updateChildValues(attribute.dict()) { (error, ref) in
            guard error == nil else {
                errorBlock(error!.localizedDescription)
                return
            }
            
            closure()
        }
    }
    
    func delete(attribute: Attribute,
                closure: @escaping () -> Void,
                errorBlock: @escaping (_ e: String) -> Void) {
        
        attributeRef(from: attribute).removeValue { (error, ref) in
            if error != nil {
                errorBlock(error!.localizedDescription)
                
            } else {
                closure()
            }
        }
    }
 }
 
 extension Coordinator {
    
    func register(email: String, password: String,
                  completion: @escaping () -> (),
                  errorBlock: @escaping (_ e: String) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                errorBlock("Crykee mates... We have an error: " + error!.localizedDescription)
                return
            }
            
            completion()
        }
    }
    
    func login(email: String, password: String,
               completion: @escaping () -> (),
               errorBlock: @escaping (_ e: String) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                errorBlock("Houstin we have an error: " + error!.localizedDescription)
                return
            }
            
            completion()
        }
    }
    
    func logout(completion: @escaping () -> (),
                errorBlock: @escaping (_ e: String) -> ()) {
        
        do {
            try Auth.auth().signOut()
        } catch let e as NSError {
            errorBlock(e.localizedDescription)
            return
        }
        
        completion()
    }
 }
 
