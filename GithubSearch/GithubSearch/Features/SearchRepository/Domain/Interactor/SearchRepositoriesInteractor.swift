//
//  SearchRepositoriesInteractor.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// 入力パラメータを正規化し、SearchRepositoriesServiceを呼び出す役割を持つ
public struct SearchRepositoriesInteractor: SearchRepositoriesUsecase, Sendable {
    private let service: SearchRepositoriesServicing

    public init(service: SearchRepositoriesServicing) {
        self.service = service
    }

    public func execute(
        query rawQuery: String,
        language: String?,
        sort: SearchRepositoriesSort?,
        order: SearchRepositoriesOrder?,
        page: Int,
        perPage: Int
    ) async throws -> (SearchRepositoriesResponse, GitHubRateLimit) {

        // 正規化（ドメイン観点で確認）
        let q = rawQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { throw SearchRepositoriesUseCaseError.emptyQuery }

        let lang = language?.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedLanguage = (lang?.isEmpty == true) ? nil : lang

        let clampedPage = max(1, page)
        let clampedPerPage = min(max(1, perPage), 100)

        // sortがnilの場合はorderもnil
        let normalizedSort = sort
        let normalizedOrder: SearchRepositoriesOrder? = (sort == nil) ? nil : order

        // リクエストに必要な情報を組み合わせる
        let req = SearchRepositoriesRequest(
            query: q,
            language: normalizedLanguage,
            sort: normalizedSort,
            order: normalizedOrder,
            page: clampedPage,
            perPage: clampedPerPage
        )
        
        return try await service.searchRepositories(req)
    }
}
