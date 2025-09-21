//
//  SearchRepositoriesViewModel.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHubリポジトリ検索の状態管理（デバウンス・distinct・ページングでレート制限と重複呼び出しを抑制）
@MainActor
public final class SearchRepositoriesViewModel: ObservableObject {
    @Published public private(set) var state = SearchRepositoryState()
    @Published var isShowMenu = false
    @Published var isShowLanguagePicker = false
    private let manager: SearchRepositoriesManager
    
    // 同一リクエストの連発を避けるためのキー
    private var lastIssuedKey: String?
    
    // 短すぎる入力は無駄な通信になるためカット
    private let minQueryLength = 1
    
    // 入力ゆらぎ対策（タイプ中の無駄な呼び出しを抑制）
    private let debounceMs = 600
    
    public init(usecase: SearchRepositoriesUsecase) {
        self.manager = SearchRepositoriesManager(usecase: usecase)
    }
    
    public func send(_ action: SearchRepositoryAction) {
        switch action {
        case .setQuery, .setLanguage, .setSort, .setOrder:
            handleInputOrFilterChange(action)   // 入力変更はデバウンスで集約
            
        case .submit:
            performSubmit()                     // 明示操作は即時実行
            
        case .reachedBottom(let currentID):
            loadNextPage(currentID: currentID)  // 末尾で次ページ
            
        case ._setLoading, ._apply, ._error:
            SearchReducer.apply(&state, action)
        }
    }
}

// MARK: - Private
private extension SearchRepositoriesViewModel {
    
    // orderはsort指定時のみ有効。未指定はGitHub既定のbest match扱いにしてキーの差分を抑制
    func makeRequestKey(_ s: SearchRepositoryState) -> String {
        let q = s.query.trimmingCharacters(in: .whitespacesAndNewlines)
        let lang = (s.language?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        
        let sortKey: String
        let orderKey: String
        
        if let sort = s.sort {
            sortKey = sort.rawValue
            orderKey = (s.order ?? .desc).rawValue
        } else {
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
    
    // 入力変更は：空文字ガード → 1ページ固定 → 発火直前のみローディング → distinct/staleチェック
    func handleInputOrFilterChange(_ action: SearchRepositoryAction) {
        SearchReducer.apply(&state, action)
        
        let trimmed = state.query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= minQueryLength else {
            Task { await manager.cancelDebounce() }
            state.items.removeAll()
            state.page = 1
            state.canLoadMore = true
            state.viewState = .idle
            return
        }
        
        state.page = 1
        let snapshot = state
        
        Task { [weak self] in
            guard let self else { return }
            await self.manager.debouncedFirstPage(
                snapshot: snapshot,
                delayMs: debounceMs,
                onWillFire: { [weak self] in
                    guard let self else { return }
                    let key = self.makeRequestKey(snapshot)
                    if self.lastIssuedKey == key { return }    // distinct
                    self.lastIssuedKey = key
                    SearchReducer.apply(&self.state, ._setLoading)
                },
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    let currentKey = self.makeRequestKey(self.state)
                    if currentKey != self.lastIssuedKey { return } // stale
                    SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: false))
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                }
            )
        }
    }
    
    // ユーザーが明示操作した場合はデバウンスを無視（即応性重視）
    func performSubmit() {
        state.page = 1
        let snapshot = state
        lastIssuedKey = makeRequestKey(snapshot)
        SearchReducer.apply(&state, ._setLoading)
        
        Task { [weak self] in
            guard let self else { return }
            await self.manager.loadFirstPage(
                snapshot: snapshot,
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    if self.makeRequestKey(self.state) != self.lastIssuedKey { return } // stale
                    SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: false))
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                }
            )
        }
    }
    
    @MainActor
    func loadNextPage(currentID: Int?) {
        guard
            let currentID,
            state.canLoadMore,
            !state.isLoadingNext,
            state.items.last?.id == currentID
        else { return }
        
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
