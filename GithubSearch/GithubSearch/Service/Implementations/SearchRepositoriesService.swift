//
//  SearchRepositoriesService.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHubリポジトリ検索を行うサービス
public final class SearchRepositoriesService: SearchRepositoriesServicing {
    private let client: HTTPClient
    private let builder: SearchRepositoriesRequestBuilder
    private let rateParser = RateLimitParser()

    public init(client: HTTPClient = GitHubHTTPClient()) {
        self.client = client
        self.builder = SearchRepositoriesRequestBuilder()
    }

    public func searchRepositories(
        _ req: SearchRepositoriesRequest
    ) async throws -> (SearchRepositoriesResponse, GitHubRateLimit) {
        // リクエストオブジェクト生成・実行
        let request = try builder.makeRequest(req)

        let (data, resp) = try await client.data(for: request)
        guard let http = resp as? HTTPURLResponse else {
            throw SearchRepositoriesServiceError.unknown
        }
        
        // レスポンスをパーシング
        let rate = rateParser.parse(http)
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 403 {
                throw SearchRepositoriesServiceError.rateLimited(resetAt: rate.resetAt)
            }
            let body = String(data: data, encoding: .utf8)
            throw SearchRepositoriesServiceError.httpStatus(http.statusCode, body)
        }

        do {
            let decoded = try JSONDecoder.github.decode(SearchRepositoriesResponse.self, from: data)
            return (decoded, rate)
        } catch {
            throw SearchRepositoriesServiceError.decoding(error)
        }
    }
}
