//
//  UIViewController+.swift
//  Things
//
//  Created by Brie Heutmaker on 2/14/17.
//  Copyright © 2017 Brie Heutmaker. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
