//
//  SearchRepositoriesViewModel.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

@MainActor
public final class SearchViewModel: ObservableObject {
    @Published public private(set) var state = SearchRepositoryState()
    private let manager: SearchRepositoriesManager

    public init(usecase: SearchRepositoriesUsecase) {
        self.manager = SearchRepositoriesManager(usecase: usecase)
    }

    public func send(_ action: SearchRepositoryAction) {
        switch action {
        // 입력/필터 변경 → 디바운스 1페이지
        case .setQuery, .setLanguage, .setSort, .setOrder:
            SearchReducer.apply(&state, action)

            if state.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                state.items.removeAll(); state.page = 1; state.canLoadMore = true; state.viewState = .idle
                return
            }

            state.page = 1
            SearchReducer.apply(&state, ._setLoading)

            // actor 호출은 비동기
            Task { [snapshot = state, weak self] in
                guard let self else { return }
                await self.manager.debouncedFirstPage(
                    snapshot: snapshot,
                    onResult: { [weak self] items, total, limit in
                        guard let self else { return }
                        // ⬇️ Reducer는 nonisolated이지만, self.state는 MainActor → 콜백 자체가 MainActor라 안전
                        SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: false))
                    },
                    onError: { [weak self] msg in
                        guard let self else { return }
                        SearchReducer.apply(&self.state, ._error(msg))
                    }
                )
            }

        // 명시 검색
        case .submit:
            state.page = 1
            SearchReducer.apply(&state, ._setLoading)

            Task { [snapshot = state, weak self] in
                guard let self else { return }
                await self.manager.loadFirstPage(
                    snapshot: snapshot,
                    onResult: { [weak self] items, total, limit in
                        guard let self else { return }
                        SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: false))
                    },
                    onError: { [weak self] msg in
                        guard let self else { return }
                        SearchReducer.apply(&self.state, ._error(msg))
                    }
                )
            }

        // 페이지네이션
        case .reachedBottom(let currentID):
            guard state.canLoadMore,
                  state.viewState != .loading,
                  state.items.last?.id == currentID else { return }

            state.page += 1
            SearchReducer.apply(&state, ._setLoading)

            Task { [snapshot = state, weak self] in
                guard let self else { return }
                await self.manager.loadMore(
                    snapshot: snapshot,
                    onResult: { [weak self] items, total, limit in
                        guard let self else { return }
                        SearchReducer.apply(&self.state, ._apply(items: items, total: total, limit: limit, append: true))
                    },
                    onError: { [weak self] msg in
                        guard let self else { return }
                        SearchReducer.apply(&self.state, ._error(msg))
                    }
                )
            }

        // 내부 액션
        case ._setLoading, ._apply, ._error:
            SearchReducer.apply(&state, action)
        }
    }
}
