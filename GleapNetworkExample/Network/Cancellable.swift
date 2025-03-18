//
//  Cancellable.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 17.03.23.
//

import Foundation

protocol Cancellable {
    var isCompleted: Bool { get }
    func cancel()
}

extension URLSessionTask: Cancellable {
    var isCompleted: Bool {
        state == .completed || state == .canceling
    }
}
