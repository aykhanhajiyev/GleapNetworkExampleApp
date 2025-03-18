//
//  Buildable.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 30.05.23.
//

import Foundation

protocol Updatable {}

extension Updatable {
    /// Updates object with passed block by creating a copy of it.
    /// - Parameter block: update block
    /// - Throws: rethrows
    /// - Returns: updated object
    func update(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

protocol Mutable {}

extension Mutable {
    /// Mutates object with passed block by creating a copy of it.
    /// - Parameter block: update block
    /// - Throws: rethrows
    /// - Returns: updated object
    mutating func mutate(_ block: (inout Self) throws -> Void) rethrows -> Self {
        try block(&self)
        return self
    }
}

protocol Buildable: Updatable, Mutable {
    init()
}

extension Buildable {
    /// Builds object applying passed block.
    /// - Parameter block: update block
    /// - Throws: rethrows
    /// - Returns: updated object
    static func build(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var instance = Self.init()
        try block(&instance)
        return instance
    }
}

extension NSObject: Buildable {}
extension Array: Buildable {}

