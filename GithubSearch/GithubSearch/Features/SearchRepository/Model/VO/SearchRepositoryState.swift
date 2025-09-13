//
//  SearchRepositoryState.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHubリポジトリ検索画面の状態を管理用
public struct SearchRepositoryState {
    var query = ""
    var language: String?
    var sort: SearchRepositoriesSort?
    var order: SearchRepositoriesOrder?
    var items: [GitHubRepository] = []
    var page = 1
    let perPage = 30
    var canLoadMore = true
    var rateLimit: GitHubRateLimit?
    enum ViewState: Equatable { case idle, loading, loaded, empty, error(String) }
    var viewState: ViewState = .idle
}
