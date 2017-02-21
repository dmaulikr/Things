//
//  Constants.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 8/14/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import Foundation

let firstIndexPath = IndexPath(row: 0, section: 0)
let secondIndexPath = IndexPath(row: 1, section: 0)

typealias Block = () -> Void
typealias Closure = (_ success: Bool) -> Void

func delay(_ delay:Double, _ closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
