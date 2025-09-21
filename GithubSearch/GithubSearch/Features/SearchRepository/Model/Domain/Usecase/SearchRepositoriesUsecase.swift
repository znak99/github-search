//
//  SearchRepositoriesUsecase.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHubリポジトリ検索のユースケース
public protocol SearchRepositoriesUsecase: Sendable {
    func execute(
        query rawQuery: String,
        language: String?,
        sort: SearchRepositoriesSort?,
        order: SearchRepositoriesOrder?,
        page: Int,
        perPage: Int
    ) async throws -> (SearchRepositoriesResponse, GitHubRateLimit)
}
