//
//  SearchReducer.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHubリポジトリ検索の状態を更新するリデューサー
enum SearchReducer {
    static func apply(_ state: inout SearchRepositoryState, _ action: SearchRepositoryAction) {
        switch action {
        case .setQuery(let q): // 検索クエリを設定
            state.query = q
        case .setLanguage(let lang): // 言語フィルターを設定（空文字ならnil）
            state.language = (lang?.isEmpty == true) ? nil : lang
        case .setSort(let s): // ソート条件を設定
            state.sort = s
        case .setOrder(let o): // 並び順を設定
            state.order = o

        case ._setLoading: // ローディング状態に変更
            state.viewState = .loading

        case ._apply(let new, let total, let limit, let append): // 検索結果を反映
            state.rateLimit = limit
            if append { state.items += new } else { state.items = new }
            state.canLoadMore = new.count == state.perPage && state.items.count < total
            state.viewState = state.items.isEmpty ? .empty : .loaded

        case ._error(let msg): // エラー状態に変更
            state.viewState = .error(msg)

        case .submit, .reachedBottom: // 検索実行やスクロール末尾到達（状態変更なし）
            break
        }
    }
}

