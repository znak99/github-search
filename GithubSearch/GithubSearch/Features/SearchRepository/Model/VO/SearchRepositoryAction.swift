//
//  SearchRepositoryAction.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHubリポジトリ検索のアクション
public enum SearchRepositoryAction {
    case setQuery(String)
    case setLanguage(String?)
    case setSort(SearchRepositoriesSort?)
    case setOrder(SearchRepositoriesOrder?)
    case submit
    case reachedBottom(Int?)
    case _applyResult(items: [GitHubRepository], total: Int, limit: GitHubRateLimit, append: Bool)
    case _setLoading(Bool)
    case _setError(String)
}
