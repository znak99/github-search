//
//  SearchRepositoriesViewModel.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

@MainActor
public final class SearchRepositoriesViewModel: ObservableObject {
    @Published public private(set) var state = SearchRepositoryState()
    @Published var isShowMenu = false
    private let manager: SearchRepositoriesManager
    
    // 最後に発行した検索キー（同じリクエストを繰り返さないためのガード）
    private var lastIssuedKey: String?
    // 検索を実行する最小文字数（短すぎる入力は無視）
    private let minQueryLength = 2
    // デバウンスの待機時間（ミリ秒）
    private let debounceMs = 600
    
    public init(usecase: SearchRepositoriesUsecase) {
        self.manager = SearchRepositoriesManager(usecase: usecase)
    }
    
    public func send(_ action: SearchRepositoryAction) {
        switch action {
            // 入力・フィルター変更時：少し待ってから検索
        case .setQuery, .setLanguage, .setSort, .setOrder:
            handleInputOrFilterChange(action)
            
            // 明示的な検索実行（Returnキーやボタン押下）：すぐに検索
        case .submit:
            performSubmit()
            
            // 一覧の末尾に達した場合：次ページを追加読み込み
        case .reachedBottom(let currentID):
            loadNextPage(currentID: currentID)
            
            // 内部用アクション：状態遷移のみを適用
        case ._setLoading, ._apply, ._error:
            SearchReducer.apply(&state, action)
        }
    }
}

// MARK: - Private
private extension SearchRepositoriesViewModel {
    
    /// 状態から一意な検索キーを生成（distinct / stale ガード用）
    /// - sort未指定のとき：GitHub既定の best_match、order は無効なので "ignored"
    func makeRequestKey(_ s: SearchRepositoryState) -> String {
        let q = s.query.trimmingCharacters(in: .whitespacesAndNewlines)
        let lang = (s.language?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        
        let sortKey: String
        let orderKey: String
        
        if let sort = s.sort {
            // sort がある場合のみ order を有効化（なければ .desc を既定とする）
            sortKey = sort.rawValue
            orderKey = (s.order ?? .desc).rawValue
        } else {
            // sort 未指定：GitHub の既定は best match。order は無効なので固定文字列で差分抑制
            sortKey = "best_match"
            orderKey = "ignored"
        }
        
        return [
            "q=\(q)",
            "lang=\(lang)",
            "sort=\(sortKey)",
            "order=\(orderKey)",
            "p=\(s.page)",
            "pp=\(s.perPage)"
        ].joined(separator: "|")
    }
    
    /// 入力・フィルター変更時：デバウンスをかけて検索を実行
    func handleInputOrFilterChange(_ action: SearchRepositoryAction) {
        SearchReducer.apply(&state, action)
        
        // 1) 空文字や短すぎる入力はリクエストしない
        let trimmed = state.query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= minQueryLength else {
            Task { await manager.cancelDebounce() } // デバウンスをキャンセル
            state.items.removeAll()
            state.page = 1
            state.canLoadMore = true
            state.viewState = .idle
            return
        }
        
        // 2) 常に最初のページから検索
        state.page = 1
        
        // 3) デバウンス：発火直前にのみローディング状態へ
        let snapshot = state
        Task { [weak self] in
            guard let self else { return }
            await self.manager.debouncedFirstPage(
                snapshot: snapshot,
                delayMs: debounceMs,
                onWillFire: { [weak self] in
                    guard let self else { return }
                    // distinct: 直前と同じキーならスキップ
                    let key = self.makeRequestKey(snapshot)
                    if self.lastIssuedKey == key { return }
                    self.lastIssuedKey = key
                    SearchReducer.apply(&self.state, ._setLoading)
                },
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    // stale ガード: 最新状態のキーと一致しなければ無視
                    let currentKey = self.makeRequestKey(self.state)
                    if currentKey != self.lastIssuedKey { return }
                    SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: false))
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                }
            )
        }
    }
    
    /// 明示的な検索実行：デバウンスを無視して即時に検索
    func performSubmit() {
        state.page = 1
        let snapshot = state
        // submit 時は常に新しいキーとして扱う
        lastIssuedKey = makeRequestKey(snapshot)
        SearchReducer.apply(&state, ._setLoading)
        
        Task { [weak self] in
            guard let self else { return }
            await self.manager.loadFirstPage(
                snapshot: snapshot,
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    // stale ガード
                    if self.makeRequestKey(self.state) != self.lastIssuedKey { return }
                    SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: false))
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                }
            )
        }
    }
    
    /// 一覧の末尾に達した場合：次ページを追加読み込み
    @MainActor
    func loadNextPage(currentID: Int?) {
        guard let currentID,
              state.canLoadMore,
              !state.isLoadingNext,
              state.items.last?.id == currentID else { return }

        let nextPage = state.page + 1

        var snapshot = state
        snapshot.page = nextPage

        state.isLoadingNext = true

        Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            await self.manager.loadMore(
                snapshot: snapshot,
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: true))
                    self.state.page = nextPage
                    self.state.isLoadingNext = false
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                    self.state.isLoadingNext = false
                }
            )
        }
    }
}
