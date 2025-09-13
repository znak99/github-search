//
//  reduce.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

/// SearchState と SearchAction の状態を更新する関数
@MainActor
func reduce(state: inout SearchRepositoryState, action: SearchRepositoryAction) {
    switch action {
    case .setQuery(let q):
        state.query = q // ユーザーが検索クエリ文字列を入力した時

    case .setLanguage(let lang):
        state.language = (lang?.isEmpty == true) ? nil : lang // 言語フィルターを変更した時

    case .setSort(let s):
        state.sort = s // ソート条件を変更したとき

    case .setOrder(let o):
        state.order = o // 順序設定を変更したとき

    case ._setLoading(let on):
        state.viewState = on ? .loading : state.viewState // APIリクエスト開始時にローディング状態にする

    case ._applyResult(let new, let total, let limit, let append):
        // APIレスポンスを反映し、結果リスト・ページング可能性・表示状態を更新する
        state.rateLimit = limit
        if append { state.items += new } else { state.items = new }
        state.canLoadMore = new.count == state.perPage && state.items.count < total
        state.viewState = state.items.isEmpty ? .empty : .loaded

    case ._setError(let msg):
        state.viewState = .error(msg) // エラー発生時にエラーメッセージを表示する状態にする

    case .submit, .reachedBottom:
        break // ユーザーが検索実行したとき、またはリストの最後に到達した時（処理は外部でハンドル）
    }
}

