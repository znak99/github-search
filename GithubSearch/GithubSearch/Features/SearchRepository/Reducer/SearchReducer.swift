//
//  SearchReducer.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHubリポジトリ検索の状態を更新するリデューサー
enum SearchReducer {
    
    static func apply(_ state: inout SearchRepositoryState, _ action: SearchRepositoryAction) {
        switch action {
            
            // ユーザー入力: 検索クエリを更新
        case .setQuery(let q):
            state.query = q
            
            // ユーザー入力: 言語フィルターを更新（空ならnilに）
        case .setLanguage(let lang):
            state.language = (lang?.isEmpty == true) ? nil : lang
            
            // ユーザー入力: ソート条件を更新
        case .setSort(let s):
            state.sort = s
            
            // ユーザー入力: 並び順を更新
        case .setOrder(let o):
            state.order = o
            
            // API呼び出し開始 → ローディング状態に変更
        case ._setLoading:
            state.viewState = .loading
            
            // API結果を反映
        case ._apply(let new, let total, let limit, let append):
            state.rateLimit = limit
            if append {
                // 追加読み込み（ページネーション）
                state.items += new
            } else {
                // 最初のページとして置き換え
                state.items = new
            }
            state.total = total
            state.canLoadMore = state.items.count < total
            state.viewState = state.items.isEmpty ? .empty : .loaded
            
            // エラーを状態に反映
        case ._error(let msg):
            state.viewState = .error(msg)
            
            // 明示的な状態変化なし（アクションは存在）
        case .submit, .reachedBottom:
            break
        }
    }
}
