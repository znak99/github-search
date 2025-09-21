//
//  CaptureRef.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/15.
//

import Foundation

final class CaptureRef<Value>: @unchecked Sendable {
    private let lock = NSLock()
    private var value: Value
    
    init(_ v: Value) { self.value = v }
    
    func set(_ v: Value) {
        lock.lock()
        value = v
        lock.unlock()
    }
    
    func get() -> Value {
        lock.lock()
        defer {
            lock.unlock()
        }
        return value
    }
}
