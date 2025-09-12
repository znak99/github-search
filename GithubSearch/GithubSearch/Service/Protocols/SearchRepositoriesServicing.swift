//
//  SearchRepositoryServicing.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

public protocol SearchRepositoriesServicing: Sendable {
    func searchRepositories(_ req: SearchRepositoriesRequest) async throws -> (SearchRepositoriesResponse, GitHubRateLimit)
}
