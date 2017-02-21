//
//  LoginViewController.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 1/13/17.
//  Copyright © 2017 Ben Heutmaker. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        usernameField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
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
            let username = usernameField.text,
            let password = passwordField.text else
        { return }
        
        Coordinator.default.login(username: username, password: password, completion: { success in
            DispatchQueue.main.async {
                self.usernameField.resignFirstResponder()
                self.passwordField.resignFirstResponder()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }) { errorString in
            DispatchQueue.main.async {
                self.showAlert(withTitle: "Login Error", message: errorString)
            }
        }
    }
}
