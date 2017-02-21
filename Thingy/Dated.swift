//
//  Dated.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 8/15/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import Foundation

protocol Dated {
    var dateCreated: Date? { get }
    var dateModified: Date? { get }
}

extension Date {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }
    
    var string: String? {
        return dateFormatter.string(from: self)
    }
}
