//
//  SearchRepositoriesManager.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHubリポジトリ検索を管理するマネージャー
public actor SearchRepositoriesManager {
    private let usecase: SearchRepositoriesUsecase
    private var currentTask: Task<Void, Never>?
    private var debounceTask: Task<Void, Never>?

    public init(usecase: SearchRepositoriesUsecase) { self.usecase = usecase }

    /// 入力の変化に対してディレイ後に検索を実行
    public func debouncedSearch(
        state snapshot: SearchRepositoryState,
        delayMs: Int = 350,
        onResult: @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit, _ append: Bool) -> Void,
        onError:  @Sendable @escaping (_ msg: String) -> Void
    ) {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
            await self.perform(state: snapshot, append: false, onResult: onResult, onError: onError)
        }
    }
    
    /// 検索を実行
    public func search(
        state snapshot: SearchRepositoryState,
        onResult: @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit, _ append: Bool) -> Void,
        onError:  @Sendable @escaping (_ msg: String) -> Void
    ) {
        Task { await self.perform(state: snapshot, append: true, onResult: onResult, onError: onError) }
    }

    /// 内部実装：UseCase を呼び出して結果を返す
    private func perform(
        state s: SearchRepositoryState,
        append: Bool,
        onResult: @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit, _ append: Bool) -> Void,
        onError:  @Sendable @escaping (_ msg: String) -> Void
    ) async {
        currentTask?.cancel()
        currentTask = Task {
            do {
                let (resp, limit) = try await usecase.execute(
                    query: s.query, language: s.language, sort: s.sort, order: s.order,
                    page: s.page, perPage: s.perPage
                )
                guard !Task.isCancelled else { return }
                await MainActor.run { onResult(resp.items, resp.totalCount, limit, append) }
            } catch is CancellationError {
                // no-op
            } catch {
                await MainActor.run { onError(error.localizedDescription) }
            }
        }
    }
}

