//
//  SearchRepositoriesManager.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHub検索のリクエスト発火タイミングとページングを一元管理するマネージャ
public actor SearchRepositoriesManager {
    
    private let usecase: SearchRepositoriesUsecase
    private var currentTask: Task<Void, Never>?
    private var debounceTask: Task<Void, Never>?
    
    public init(usecase: SearchRepositoriesUsecase) { self.usecase = usecase }
    
    // MARK: - Debounce（無駄リクエスト抑制のための遅延発火）
    
    // 入力が短時間で変化する場合に、古いデバウンスを打ち切る
    public func cancelDebounce() { debounceTask?.cancel() }
    
    // タイプ中の連打を避けるため、少し待ってから最初のページを検索
    // onWillFireは「本当に投げる直前」にローディング反映が必要なため
    public func debouncedFirstPage(
        snapshot: SearchRepositoryState,
        delayMs: Int = 600,
        onWillFire: @MainActor @Sendable @escaping () -> Void,
        onResult:   @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:    @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        debounceTask?.cancel()
        
        debounceTask = Task {
            // ユーザー入力が続く間は待機し、連続API呼び出しを避けるため
            try? await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
            guard !Task.isCancelled else { return }
            
            await MainActor.run { onWillFire() }
            await self.perform(snapshot: snapshot, append: false, onResult: onResult, onError: onError)
        }
    }
    
    // MARK: - Paging API
    
    // 即時で最初のページを取得（初回/フィルタ確定時に使用）
    public func loadFirstPage(
        snapshot: SearchRepositoryState,
        onResult: @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:  @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        await perform(snapshot: snapshot, append: false, onResult: onResult, onError: onError)
    }
    
    // 次ページを取得して結果を後ろに連結（無限スクロール用）
    public func loadMore(
        snapshot: SearchRepositoryState,
        onResult: @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:  @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        await perform(snapshot: snapshot, append: true, onResult: onResult, onError: onError)
    }
    
    // MARK: - Internal
    
    // 前回のリクエストを確実にキャンセルしてから新規リクエストを実行（重複更新を避けるため）
    private func perform(
        snapshot s: SearchRepositoryState,
        append: Bool,
        onResult: @MainActor @Sendable @escaping (_ items: [GitHubRepository], _ total: Int, _ limit: GitHubRateLimit) -> Void,
        onError:  @MainActor @Sendable @escaping (_ msg: String) -> Void
    ) async {
        currentTask?.cancel()
        
        currentTask = Task {
            do {
                // UseCaseに集約しておくことで、API仕様変更時の影響範囲を局所化するため
                let (resp, limit) = try await usecase.execute(
                    query: s.query, language: s.language, sort: s.sort, order: s.order,
                    page: s.page, perPage: s.perPage
                )
                guard !Task.isCancelled else { return }
                
                await MainActor.run { onResult(resp.items, resp.totalCount, limit) }
                
            } catch is CancellationError {
                // ユーザー操作によるキャンセルは正常系として無視
            } catch {
                // 画面側に単純な文言だけ渡し、詳細はログ側で持つ想定
                await MainActor.run { onError(error.localizedDescription) }
            }
        }
    }
}
