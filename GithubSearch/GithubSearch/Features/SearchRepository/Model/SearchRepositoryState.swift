//
//  SearchRepositoryState.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHubリポジトリ検索画面の状態
public struct SearchRepositoryState {
    
    // 検索条件
    var query = ""
    var language: String?
    var sort: SearchRepositoriesSort?
    var order: SearchRepositoriesOrder?
    
    // 結果・ページング
    var items: [GitHubRepository] = []
    var page = 1
    let perPage = 30
    var total = 0
    var canLoadMore = true
    var isLoadingNext = false
    
    // レート制限
    var rateLimit: GitHubRateLimit?
    
    /// 画面表示状態
    enum ViewState: Equatable {
        case idle, loading, loaded, empty, error(String)
    }
    
    var viewState: ViewState = .idle
}
