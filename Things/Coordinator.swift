 //
 //  ThingDataCoordinator.swift
 //  Things
 //
 //  Created by Brie Heutmaker on 5/18/16.
 //  Copyright © 2016 Brie Heutmaker. All rights reserved.
 //
 
 import UIKit
 import Just
 
 enum CoordinatorErrorType {
    case objectNil
 }
 
 struct Coordinator {
    
    static let baseURL = "http://ec2-52-201-91-9.compute-1.amazonaws.com/api/v1"
    func authHeader() -> [String:String] {
        return ["Authorization" : "Bearer \(AppState.shared.accessToken ?? "")"]
    }
    
    func getAllThings(gotOne: @escaping (_ thing: Thing) -> Void,
                      errorBlock: @escaping (_ e: String) -> Void,
                      completed: @escaping () -> ()) {
        
        let url = Coordinator.baseURL + "/things"
        let errorString = "Couldn't get all the Things 😳\n"
        
        Just.get(url, headers: authHeader()) { r in
            
            guard r.json != nil else {
                print("JSON is nil")
                completed()
                return
            }
            
            guard let json = r.json as? [String : Any] else {
                errorBlock(errorString + "Returned JSON is not convertable to Dictionary!")
                return
            }
            
            if r.ok {
                guard let array = json["things"] as? [[String : Any]] else {
                    errorBlock(errorString + "No array found")
                    return
                }
                
                for dict in array {
                    let thing = Thing(from: dict)
                    gotOne(thing)
                }
                
                completed()
                
            } else {
                let error = json["error"] as? String
                errorBlock(errorString + (error ?? "Status Code: \(String(describing: r.statusCode))"))
            }
        }
    }
    
    func save(_ thing: Thing,
              closure: @escaping (_ thing: Thing) -> Void,
              errorBlock: @escaping (_ e: String) -> Void) {
        
        let url = Coordinator.baseURL + "/things"
        let params: [String : Any] = ["name" : thing.name, "icon": thing.icon]
        let errorString = "The Thing didn't save at all 😳\n"
        
        Just.post(url, data: params, headers: authHeader()) { r in
            guard let dict = r.json as? [String : Any] else {
                errorBlock(errorString + "Returned JSON is not convertable to Dictionary!")
                return
            }
            
            if r.ok {
                guard let thingDict = dict["thing"] as? [String : Any] else {
                    errorBlock(errorString + "Could not find dictionary with key \"thing\"")
                    return
                }
                
                let thing = Thing(from: thingDict)
                closure(thing)
                
            } else {
                let error = dict["error"] as? String
                errorBlock(errorString + (error ?? "Status Code: \(String(describing: r.statusCode))"))
            }
        }
    }
    
    func delete(thing: Thing,
                closure: @escaping () -> Void,
                errorBlock: @escaping (_ e: String) -> Void) {
        
        let url = Coordinator.baseURL + "/things/\(thing.id)"
        let errorString = "An error means you are stuck with this Thing 😂\n"
        
        Just.delete(url, headers: authHeader()) { r in
            if r.ok {
                closure()
                
            } else {
                guard let dict = r.json as? [String : Any] else {
                    errorBlock(errorString + "Returned JSON is not convertable to Dictionary!")
                    return
                }
                
                let error = dict["error"] as? String
                errorBlock(errorString + (error ?? "Status Code: \(String(describing: r.statusCode))"))
            }
        }
    }
    
    func save(_ attribute: Attribute,
              closure: @escaping (_ attribute: Attribute) -> Void,
              errorBlock: @escaping (_ e: String) -> Void) {
        
        let url = Coordinator.baseURL + "/attributes"
        let params: [String : Any] = attribute.dict()
        
        Just.post(url, data: params, headers: authHeader()) { r in
            
            let errorString = "Saving Attribute failed miserably...\n"
            
//            print(r.json!)
            
            guard let dict = r.json as? [String : Any] else {
                errorBlock(errorString + "Returned JSON is not convertable to Dictionary!")
                return
            }
            
            if r.ok {
                guard let newAttribute = AttributeHelper.attribute(from: dict) else {
                    errorBlock(errorString + "Could not create Attribute object from returned Dictionary!")
                    return
                }
                
                closure(newAttribute)
                
            } else {
                let error = dict["error"] as? String
                errorBlock(errorString + (error ?? "Status Code: \(String(describing: r.statusCode))"))
            }
        }
    }
    
    func update(_ attribute: Attribute,
                closure: @escaping (_ attribute: Attribute) -> Void,
                errorBlock: @escaping (_ e: String) -> Void) {
        
        let url = Coordinator.baseURL + "/attributes/\(attribute.id)"
        let params: [String:Any] = attribute.dict()
        let errorString = "... We... Couldn't update it...?\n"
        
        Just.put(url, data: params, headers: authHeader()) { r in
            
            guard let dict = r.json as? [String:Any] else {
                errorBlock(errorString + "Returned JSON is not convertable to Dictionary!")
                return
            }
            
            if r.ok {
                
                guard let newAttribute = AttributeHelper.attribute(from: dict) else {
                    errorBlock(errorString + "Could not create Attribute object from returned Dictionary!")
                    return
                }
                
                closure(newAttribute)
            
            } else {
                let error = dict["error"] as? String
                errorBlock(errorString + (error ?? "Status Code: \(String(describing: r.statusCode))"))
            }
        }
    }
    
    func getAllAttributes(from thing: Thing,
                    gotOne: @escaping (_ attribute: Attribute) -> Void,
                    errorBlock: @escaping (_ e: String) -> Void,
                    completed: @escaping () -> ()) {
        
        let url = Coordinator.baseURL + "/attributes?parent=\(thing.id)"
        
        let errorString = "Getting this Thing's Attributes didn't work...\n"
        
        Just.get(url, headers: authHeader()) { r in
            
            guard let dict = r.json as? [String : Any] else {
                errorBlock(errorString + "Returned JSON is not convertable to Dictionary!")
                return
            }
            
            if r.ok {
                guard let array = dict["attributes"] as? [[String : Any]] else {
                    errorBlock(errorString + "No array found")
                    return
                }
                
                for dict in array {
                    guard let attribute = AttributeHelper.attribute(from: dict) else {
                        errorBlock(errorString + "Could not create Attribute object from given Dictionary")
                        continue
                    }
                    
                    gotOne(attribute)
                }
                
                completed()
                
            } else {
                let error = dict["error"] as? String
                errorBlock(errorString + (error ?? "Status Code: \(String(describing: r.statusCode))"))
            }
        }
    }
    
    func delete(attribute: Attribute,
                closure: @escaping () -> Void,
                errorBlock: @escaping (_ e: String) -> Void) {
        
        let url = Coordinator.baseURL + "/attributes/\(attribute.id)"
        let errorString = "You can't delete it, it's broken 😭 (But it's not your fault)\n"
        
        Just.delete(url, headers: authHeader()) { r in
            if r.ok {
                closure()
                
            } else {
                
                guard r.json != nil else {
                    errorBlock("Status Code: \(String(describing: r.statusCode))")
                    return
                }
                
                guard let dict = r.json as? [String : Any] else {
                    errorBlock(errorString + "Returned JSON is not convertable to Dictionary!")
                    return
                }
                
                let error = dict["error"] as? String
                errorBlock(errorString + (error ?? "Status Code: \(String(describing: r.statusCode))"))
            }
        }
    }
 }
 
 extension Coordinator {
    
    func register(username: String, password: String,
                  completion: @escaping (_ success: Bool) -> Void) {
        
        let url = Coordinator.baseURL + "/register"
        let params = ["username": username, "password": password]
        
        Just.post(url, data: params, headers: authHeader()) { r in
            if r.ok {
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
    
    func login(username: String, password: String,
               completion: @escaping () -> Void,
               errorBlock: @escaping (_ error: String) -> Void) {
        
        let url = Coordinator.baseURL + "/login"
        let params = ["username" : username, "password" : password]
        
        Just.post(url, data: params) { r in
            if r.ok {
                guard let dict = r.json as? [String:Any] else { fatalError() }
                guard let error = dict["error"] as? String else { fatalError() }
                
                if error != "none" {
                    errorBlock(error)
                    return
                }
                
                guard let token = dict["token"] as? String else { fatalError() }
                AppState.shared.accessToken = token
                AppState.shared.username = username
                
                completion()
                
            } else{
                errorBlock("Status code: \(String(describing: r.statusCode))")
            }
        }
    }
    
    func logout(completion: (_ success: Bool) -> ()) {
        
        let url = Coordinator.baseURL + "/logout"
        let logout = Just.get(url, headers: authHeader())
        
        if logout.ok {
            AppState.shared.accessToken = nil
            AppState.shared.signedIn = false
            AppState.shared.username = nil
            
            completion(true)
        
        } else {
            completion(false)
        }
    }
 }
 
