//
//  RegisterViewController.swift
//  Things
//
//  Created by Brie Heutmaker on 1/13/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    var coordinator: Coordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        usernameField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
            
        } else if textField == confirmPasswordField {
            register()
        }
        
        return true
    }
    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        register()
    }
    
    private func register() {
        guard passwordField.text == confirmPasswordField.text else { return }
        guard let username = usernameField.text, let password = passwordField.text else { return }
        
        coordinator.register(username: username, password: password) { success in
            
            if success {
                
                self.coordinator.login(username: username, password: password, completion: {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "registerSegue", sender: nil)
                    }
                    
                }, errorBlock: { errorString in
                    DispatchQueue.main.async {
                        self.showAlert(withTitle: "Login Failed", message: errorString)
                    }
                })
                
            } else {
                DispatchQueue.main.async {
                    self.showAlert(withTitle: "Failed", message: "Failed to register")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.confirmPasswordField.resignFirstResponder()
    }
}

