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

    case submit // 検索
    case reachedBottom(currentID: Int?) // 最後のデータ表示時

    // 内部状態更新用
    case _setLoading
    case _apply(items: [GitHubRepository], total: Int, limit: GitHubRateLimit, append: Bool)
    case _error(String)
}
