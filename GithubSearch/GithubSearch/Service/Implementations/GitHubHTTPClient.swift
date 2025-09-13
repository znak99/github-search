//
//  GitHubHTTPClient.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHub用に生成されたリクエストを実行
public struct GitHubHTTPClient: HTTPClient {
    public init() {}
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await URLSession.githubDefault.data(for: request)
    }
}
