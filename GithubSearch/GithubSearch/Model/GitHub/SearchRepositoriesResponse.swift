//
//  SearchRepositoriesResponse.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

struct SearchRepositoriesResponse: Decodable, Equatable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [GitHubRepository]

    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
