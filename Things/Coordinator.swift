 //
 //  ThingDataCoordinator.swift
 //  Things
 //
 //  Created by Brianna Lee on 5/18/16.
 //  Copyright © 2016 Exoteric Design. All rights reserved.
 //
 
 import UIKit
 import FirebaseAuth
 import FirebaseDatabase
 
 enum CoordinatorErrorType {
    case objectNil
 }
 
 struct Coordinator {
    
    func thingRef(with id: String) -> DatabaseReference {
        let thingRef = Database.database().reference(withPath: "humans/\(AppState.shared.uid ?? "")/things/\(id)/")
        return thingRef
    }
    
    func attributeRef(from attribute: Attribute) -> DatabaseReference {
        let attributeRef = Database.database().reference(withPath: "humans/\(AppState.shared.uid ?? "")/things/\(attribute.parent ?? "")/attributes/\(attribute.id ?? "")/")
        return attributeRef
    }
    
    func save(_ thing: Thing,
              closure: @escaping () -> Void,
              errorBlock: @escaping (_ e: String) -> Void) {
        
        guard let id = thing.id else {
            errorBlock("Yeah the thing doesn't have an ID.... That's actually the error you should tell the developers.")
            return
        }
        
        thingRef(with: id).updateChildValues(thing.dict()) { (error, ref) in
            guard error == nil else {
                errorBlock("Didn't save! Here's why: " + error!.localizedDescription)
                return
            }
            
            closure()
        }
    }
    
    func delete(thing: Thing,
                closure: @escaping () -> Void,
                errorBlock: @escaping (_ e: String) -> Void) {
        
        guard let id = thing.id else {
            errorBlock("Yeah the thing doesn't have an ID.... That's actually the error you should tell the developers.")
            return
        }
        
        thingRef(with: id).removeValue { (error, ref) in
            if error != nil {
                errorBlock("So we're gonna give it to you straight. The Thing didn't delete and there was an error: " + error!.localizedDescription)
            
            } else {
                closure()
            }
        }
    }
    
    
    
    func save(_ attribute: Attribute,
              closure: @escaping () -> Void,
              errorBlock: @escaping (_ e: String) -> Void) {
        
        attributeRef(from: attribute).updateChildValues(attribute.dict()) { (error, ref) in
            guard error == nil else {
                errorBlock("Wait... It didn't save there was an error: " + error!.localizedDescription)
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
                errorBlock("Yo... Error: " + error!.localizedDescription)
                
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
            errorBlock("So you can't logout! Haha you're stuck with us! 🤣/nNo no, but really here's the error: " + e.localizedDescription)
            return
        }
        
        completion()
    }
 }
 
