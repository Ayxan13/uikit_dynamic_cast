//
//  OperatorExtensions.swift
//  uikit_dynamic_cast
//
//  Created by Ayxan on 08.09.21.
//

extension Int {
    @discardableResult
    static prefix func ++(x: inout Int) -> Int {
        x += 1;
        return x;
    }

    static postfix func ++(x: inout  Int) -> Int {
        defer { x += 1; }
        return x;
    }

    @discardableResult
    static prefix func --(x: inout Int) -> Int {
        x -= 1;
        return x;
    }

    static postfix func --(x: inout Int) -> Int {
        defer { x -= 1; }
        return x;
    }
}
