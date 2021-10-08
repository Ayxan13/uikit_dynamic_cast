//
//  Optional.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 08.10.21.
//

import Foundation

precedencegroup OptionalAssignment { associativity: right assignment: true }

infix operator ?= : OptionalAssignment

// Assign right side to left iff right side is not nil
public func ?= <T>(variable: inout T, value: T?) {
    if let value = value {
        variable = value
    }
}
