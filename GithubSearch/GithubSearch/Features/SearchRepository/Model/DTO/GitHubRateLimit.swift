//
//  GitHubRateLimit.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHub APIのレート制限情報
public struct GitHubRateLimit: Sendable {
    public let limit: Int?
    public let remaining: Int?
    public let resetAt: Date?
}
