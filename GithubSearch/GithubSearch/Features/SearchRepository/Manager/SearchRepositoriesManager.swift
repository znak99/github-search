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

    /// 入力を少し待ってから最初のページを検索する（タイプ中の無駄なリクエストを抑える）
    public func debouncedFirstPage(
        snapshot: SearchRepositoryState,
        delayMs: Int = 350,
        onResult: @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:  @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
            await self.perform(snapshot: snapshot, append: false, onResult: onResult, onError: onError)
        }
    }

    /// すぐに最初のページを検索して結果を取得する
    public func loadFirstPage(
        snapshot: SearchRepositoryState,
        onResult: @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:  @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        await perform(snapshot: snapshot, append: false, onResult: onResult, onError: onError)
    }

    /// 次のページを読み込みリストに続けて追加する
    public func loadMore(
        snapshot: SearchRepositoryState,
        onResult: @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:  @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        await perform(snapshot: snapshot, append: true, onResult: onResult, onError: onError)
    }

    /// 指定状態に基づいて検索を実行し、必要ならリストに追加する
    private func perform(
        snapshot s: SearchRepositoryState,
        append: Bool,
        onResult: @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:  @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        currentTask?.cancel()
        currentTask = Task {
            do {
                let (resp, limit) = try await usecase.execute(
                    query: s.query, language: s.language, sort: s.sort, order: s.order,
                    page: s.page, perPage: s.perPage
                )
                guard !Task.isCancelled else { return }
                await MainActor.run { onResult(resp.items, resp.totalCount, limit) }
            } catch is CancellationError {
                // キャンセル時
            } catch {
                await MainActor.run { onError(error.localizedDescription) }
            }
        }
    }
}
