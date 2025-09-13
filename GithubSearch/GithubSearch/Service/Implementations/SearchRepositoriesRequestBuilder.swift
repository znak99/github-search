//
//  SearchRequestBuilder.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHubリポジトリ検索用のリクエストを生成
struct SearchRepositoriesRequestBuilder {
    let baseURL: URL

    init() {
        self.baseURL = URL(string: AppConfig.API.baseURL)!
    }

    func makeRequest(_ req: SearchRepositoriesRequest) throws -> URLRequest {
        // クエリの有効性確認
        let raw = req.query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { throw SearchRepositoriesServiceError.invalidQuery }
        var q = raw
        if let lang = req.language, !lang.isEmpty { q += " language:\(lang)" }

        // URLオブジェクト生成
        guard var comps = URLComponents(
            url: baseURL.appending(path: AppConfig.API.searchRepositories),
            resolvingAgainstBaseURL: false
        ) else {
            throw SearchRepositoriesServiceError.invalidURL
        }
        
        var items: [URLQueryItem] = [
            .init(name: "q", value: q),
            .init(name: "page", value: String(max(1, req.page))),
            .init(name: "per_page", value: String(min(max(1, req.perPage), 100)))
        ]
        if let sort = req.sort { items.append(.init(name: "sort", value: sort.rawValue)) }
        if let order = req.order { items.append(.init(name: "order", value: order.rawValue)) }
        comps.queryItems = items
        guard let url = comps.url else { throw SearchRepositoriesServiceError.invalidURL }
        
        // 生成したオブジェクトを用いてリクエストオブジェクト生成
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
