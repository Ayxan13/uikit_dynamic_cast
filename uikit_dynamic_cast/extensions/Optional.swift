//
//  Optional.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan Haqverdili on 08.10.21.
//

import Foundation

/// [Optional Assignment]
precedencegroup OptionalAssignment { associativity: right assignment: true }

infix operator ?= : OptionalAssignment

// Assign right side to left iff right side is not nil
public func ?= <T>(variable: inout T, value: T?) {
    if let value = value {
        variable = value
    }
}


/// [Is Nil Or Empty]
extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        self?.isEmpty ?? true;
    }
}
