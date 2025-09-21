//
//  Fixture.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation
@testable import GithubSearch

enum Fixture {
    static func data(named name: String, ext: String = "json") throws -> Data {
        let bundle = Bundle(for: DummyClass.self)
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            throw NSError(domain: "Fixture", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing \(name).json"])
        }
        return try Data(contentsOf: url)
    }
    private final class DummyClass {}
}
