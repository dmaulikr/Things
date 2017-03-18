//
//  SplashViewController.swift
//  Things
//
//  Created by Brie Heutmaker on 1/13/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var coordinator: Coordinator!
    
    override func viewDidLoad() {
        if coordinator == nil {
            coordinator = Coordinator()
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToSplash(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "registerSegue" {
            guard
                let navController = segue.destination as? UINavigationController,
                let registerViewController = navController.viewControllers.first as? RegisterViewController
            else { fatalError() }
            registerViewController.coordinator = self.coordinator
        }
        
        if segue.identifier == "loginSegue" {
            guard
                let navController = segue.destination as? UINavigationController,
                let loginViewController = navController.viewControllers.first as? LoginViewController
                else {
                    fatalError()
            }
            loginViewController.coordinator = self.coordinator
        }
    }
}
