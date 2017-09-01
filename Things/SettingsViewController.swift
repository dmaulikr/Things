
//  SettingsViewController.swift
//  Things
//
//  Created by Brianna Lee on 1/13/17.
//  Copyright © 2017 Exoteric Design. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var coordinator: Coordinator!
    
    @IBOutlet var loggedInAsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize.height = self.tableView.contentSize.height + self.navigationController!.navigationBar.frame.height + 44
        
        loggedInAsLabel.text = "Logged in as \(AppState.shared.email ?? "SOMEONE 😰 (We don't know)")"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.reuseIdentifier == "LogoutCell" {
            signOut()
        }
    }
    
    func signOut() {
        coordinator.logout(completion: { 
            guard let splash = self.storyboard?.instantiateViewController(withIdentifier: "SplashViewController") else {
                self.showAlert(title: "Could not find the Splash Screen", message: "It's lost in the sci-fi thought realm somewhere....")
                return
            }
            
            self.present(splash, animated: true, completion: {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.removeFromParentViewController()
            })
            
        }) { e in
            self.showAlert(title: "Can't Logout", message: "Could not logout for whatever reason... Sorry, you're stuck with us! 😹")
        }
    }
    
}
