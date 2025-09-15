//
//  SearchRepositoryAction.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// 検索機能の状態遷移に使う「外部操作」と「内部更新」を表すイベント列挙
public enum SearchRepositoryAction {
    
    // MARK: - User Actions (外部からの操作)
    case setQuery(String)
    case setLanguage(String?)
    case setSort(SearchRepositoriesSort?)
    case setOrder(SearchRepositoriesOrder?)
    case submit
    case reachedBottom(currentID: Int?)
    
    // MARK: - Internal Updates (内部状態の更新)
    case _setLoading
    case _apply(items: [GitHubRepository], total: Int, limit: GitHubRateLimit, append: Bool)
    case _error(String)
}
