//
//  LoginViewController.swift
//  Things
//
//  Created by Brie Heutmaker on 1/13/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate {
    
    var coordinator: Coordinator!
    
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
        
        coordinator.login(username: username, password: password, completion: { success in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
}
