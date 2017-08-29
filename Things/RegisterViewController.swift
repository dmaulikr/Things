//
//  RegisterViewController.swift
//  Things
//
//  Created by Brie Heutmaker on 1/13/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    var coordinator: Coordinator!
    var authHandler: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize.height = 340
        
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        emailField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authHandler = Auth.auth().addStateDidChangeListener { auth, user in
            guard auth.currentUser != nil else {
                AppState.shared.signedIn = false
                return
            }
            
            AppState.shared.signedIn = true
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authHandler)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
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
        guard passwordField.text == confirmPasswordField.text else {
            showAlert(title: "Passwords do not match", message: "Please reenter your passwords and try again.")
            
            self.passwordField.text = ""
            self.confirmPasswordField.text = ""
            
            return
        }
        
        guard
            let password = passwordField.text,
            let email = emailField.text
            else {
                showAlert(title: "All fields are required", message: "Please fill out all fields and try again.")
                return
        }
        
        coordinator.register(email: email, password: password, completion: {
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            }
            
        }) { e in
            DispatchQueue.main.async {
                self.showAlert(title: "Failed", message: e)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.confirmPasswordField.resignFirstResponder()
    }
}

