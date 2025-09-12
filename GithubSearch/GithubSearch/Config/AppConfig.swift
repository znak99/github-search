//
//  AppConfig.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

/// アプリ全体で使用する設定値定義
enum AppConfig {
    enum API {
        static let baseURL = "https://api.github.com"
        static let searchRepositories = "/search/repositories"
        
        // GitHub REST API version
        static let version = "2022-11-28"
        
        static var defaultHeaders: [String: String] {
            [
                "Accept": "application/vnd.github+json",
                "X-GitHub-Api-Version": version
                // "Authorization": "Bearer <token>"
            ]
        }
    }
}
