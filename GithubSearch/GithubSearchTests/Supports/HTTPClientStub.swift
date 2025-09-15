//
//  HTTPClientStub.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/15.
//

import Foundation
@testable import GithubSearch

struct HTTPClientStub: HTTPClient, @unchecked Sendable {
    let handler: @Sendable (URLRequest) throws -> (Data, URLResponse)
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try handler(request)
    }
}

extension URLResponse {
    static func http(url: URL, status: Int, headers: [String:String] = [:]) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: headers)!
    }
}
