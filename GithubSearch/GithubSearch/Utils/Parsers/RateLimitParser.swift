//
//  RateLimitParser.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHub API レート制限ヘッダーを解析し、利用可能な回数やリセット時刻を取得するオブジェクト
struct RateLimitParser {
    func parse(_ http: HTTPURLResponse) -> GitHubRateLimit {
        let limit = http.value(forHTTPHeaderField: "X-RateLimit-Limit").flatMap(Int.init)
        let remaining = http.value(forHTTPHeaderField: "X-RateLimit-Remaining").flatMap(Int.init)
        let resetAt = http.value(forHTTPHeaderField: "X-RateLimit-Reset")
            .flatMap(Double.init).map { Date(timeIntervalSince1970: $0) }
        return GitHubRateLimit(limit: limit, remaining: remaining, resetAt: resetAt)
    }
}
