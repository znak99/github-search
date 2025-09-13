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
    private let manager: SearchRepositoriesManager
    
    public init(usecase: SearchRepositoriesUsecase) {
        self.manager = SearchRepositoriesManager(usecase: usecase)
    }
    
    public func send(_ action: SearchRepositoryAction) {
        switch action {
            
            // 入力・フィルター変更時：少し待ってから最初のページを検索
        case .setQuery, .setLanguage, .setSort, .setOrder:
            handleInputOrFilterChange(action)
            
            // 明示的な検索実行：すぐに最初のページを取得
        case .submit:
            performSubmit()
            
            // ページネーション：一覧の末尾に達したら次ページを追加読み込み
        case .reachedBottom(let currentID):
            loadNextPageIfNeeded(currentID: currentID)
            
            // 内部用アクション：状態遷移のみを適用
        case ._setLoading, ._apply, ._error:
            SearchReducer.apply(&state, action)
        }
    }
}

// MARK: - Private Helpers
private extension SearchRepositoriesViewModel {
    /// 入力・フィルター変更時：少し待ってから最初のページを検索
    func handleInputOrFilterChange(_ action: SearchRepositoryAction) {
        SearchReducer.apply(&state, action)
        
        if state.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            state.items.removeAll()
            state.page = 1
            state.canLoadMore = true
            state.viewState = .idle
            return
        }
        
        state.page = 1
        SearchReducer.apply(&state, ._setLoading)
        
        let snapshot = state
        Task { [weak self] in
            guard let self else { return }
            await self.manager.debouncedFirstPage(
                snapshot: snapshot,
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    SearchReducer.apply(
                        &self.state,
                        ._apply(items: items, total: total, limit: limit, append: false)
                    )
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                }
            )
        }
    }
    
    /// 明示的な検索実行：すぐに最初のページを取得
    func performSubmit() {
        state.page = 1
        SearchReducer.apply(&state, ._setLoading)
        
        let snapshot = state
        Task { [weak self] in
            guard let self else { return }
            await self.manager.loadFirstPage(
                snapshot: snapshot,
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    SearchReducer.apply(
                        &self.state,
                        ._apply(items: items, total: total, limit: limit, append: false)
                    )
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                }
            )
        }
    }
    
    /// ページネーション：一覧の末尾に達したら次ページを追加読み込み
    func loadNextPageIfNeeded(currentID: Int?) {
        guard let currentID, // Optional 바인딩
              state.canLoadMore,
              state.viewState != .loading,
              state.items.last?.id == currentID
        else { return }
        
        state.page += 1
        SearchReducer.apply(&state, ._setLoading)
        
        let snapshot = state
        Task { [weak self] in
            guard let self else { return }
            await self.manager.loadMore(
                snapshot: snapshot,
                onResult: { [weak self] items, total, limit in
                    guard let self else { return }
                    SearchReducer.apply(
                        &self.state,
                        ._apply(items: items, total: total, limit: limit, append: true)
                    )
                },
                onError: { [weak self] msg in
                    guard let self else { return }
                    SearchReducer.apply(&self.state, ._error(msg))
                }
            )
        }
    }
}
