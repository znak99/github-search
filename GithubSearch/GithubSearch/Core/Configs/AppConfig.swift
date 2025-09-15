//
//  AppConfig.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

// アプリ全体で使用する設定値定義
public enum AppConfig {
    public enum API {
        static let baseURL = "https://api.github.com"
        static let searchRepositories = "/search/repositories"
        
        // GitHub REST APIバージョン
        static let version = "2022-11-28"
        

        static var defaultHeaders: [String: String] {
            [
                "Accept": "application/vnd.github+json",
                "X-GitHub-Api-Version": version,
                "User-Agent": "GithubSearch/1.0 (iOS)"
            ]
        }
    }
}
