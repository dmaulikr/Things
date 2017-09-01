//
//  LoginViewController.swift
//  Things
//
//  Created by Brianna Lee on 1/13/17.
//  Copyright © 2017 Exoteric Design. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var coordinator: Coordinator!
    var authHandler: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authHandler = Auth.auth().addStateDidChangeListener {
            auth, user in
            
            guard auth.currentUser != nil else {
                AppState.shared.signedIn = false
                return
            }
            
            AppState.shared.signedIn = true
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
            login()
        }
        
        return true
    }
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        login()
    }
    
    private func login() {
        guard
            let email = emailField.text,
            let password = passwordField.text else
        { return }
        
        coordinator.login(email: email, password: password, completion: {
            DispatchQueue.main.async {
                self.emailField.resignFirstResponder()
                self.passwordField.resignFirstResponder()
            }
        }) { errorString in
            DispatchQueue.main.async {
                self.showAlert(title: "Login Error", message: errorString)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
}
