//
//  Dated.swift
//  Things
//
//  Created by Brianna Lee on 8/15/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import Foundation

protocol Dated {
    var created: String? { get }
    var updated: String? { get }
}

extension Date {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }
    
    var string: String? {
        return Date.dateFormatter.string(from: self)
    }
    
    static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}
