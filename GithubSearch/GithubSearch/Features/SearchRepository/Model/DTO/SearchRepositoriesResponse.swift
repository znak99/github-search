//
//  GitHubRepositoriesResponse.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

// GitHubリポジトリ検索APIのレスポンスモデル
public struct SearchRepositoriesResponse: Decodable, Equatable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [GitHubRepository]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
