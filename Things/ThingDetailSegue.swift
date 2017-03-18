//
//  ThingDetailSegue.swift
//  Things
//
//  Created by Brie Heutmaker on 5/12/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import UIKit

class ThingDetailSegue: UIStoryboardSegue {
    
    var indexPath: IndexPath?
    
    override func perform() {
        
        let appDelegate = UIApplication.shared.keyWindow
        
        
        if let splitViewController = appDelegate?.rootViewController as? SplitThingsViewController {
            
            if splitViewController.viewControllers.count > 1 {
                source.performSegue(withIdentifier: "showDetailSplitDevice", sender: indexPath)
            
            } else {
                source.performSegue(withIdentifier: "showDetail", sender: indexPath)
            }
        }
    }

}
