//
//  SearchRepositoriesService.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

public final class SearchRepositoriesService: SearchRepositoriesServicing {
    private let session: URLSession
    private let base = URL(string: "https://api.github.com")!
    private let token: String?

    public init(session: URLSession = .githubDefault, token: String? = nil) {
        self.session = session
        self.token = token
    }

    public func searchRepositories(_ req: SearchRepositoriesRequest) async throws -> (SearchRepositoriesResponse, GitHubRateLimit) {
        guard !req.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SearchRepositoriesServiceError.invalidQuery
        }

        var comps = URLComponents(url: base.appending(path: "/search/repositories"), resolvingAgainstBaseURL: false)!
        // q = query (+ language:xxx)
        var q = req.query
        if let lang = req.language, !lang.isEmpty {
            q += " language:\(lang)"
        }
        var items: [URLQueryItem] = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "page", value: String(max(1, req.page))),
            URLQueryItem(name: "per_page", value: String(min(max(1, req.perPage), 100)))
        ]
        if let sort = req.sort { items.append(.init(name: "sort", value: sort.rawValue)) }
        if let order = req.order { items.append(.init(name: "order", value: order.rawValue)) }
        comps.queryItems = items

        var urlRequest = URLRequest(url: comps.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        if let token { urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }

        do {
            let (data, resp) = try await session.data(for: urlRequest)
            guard let http = resp as? HTTPURLResponse else { throw SearchRepositoriesServiceError.unknown }

            let rate = parseRateLimit(http)

            switch http.statusCode {
            case 200:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let decoded = try decoder.decode(SearchRepositoriesResponse.self, from: data)
                    return (decoded, rate)
                } catch {
                    throw SearchRepositoriesServiceError.decoding(error)
                }

            case 403:
                // レート制限 or ポリシー
                throw SearchRepositoriesServiceError.rateLimited(resetAt: rate.resetAt)

            default:
                let message = String(data: data, encoding: .utf8)
                throw SearchRepositoriesServiceError.httpStatus(http.statusCode, message)
            }
        } catch let err as SearchRepositoriesServiceError {
            throw err
        } catch {
            throw SearchRepositoriesServiceError.transport(error)
        }
    }

    private func parseRateLimit(_ http: HTTPURLResponse) -> GitHubRateLimit {
        let limit = http.value(forHTTPHeaderField: "X-RateLimit-Limit").flatMap(Int.init)
        let remaining = http.value(forHTTPHeaderField: "X-RateLimit-Remaining").flatMap(Int.init)
        let resetAt: Date? = http.value(forHTTPHeaderField: "X-RateLimit-Reset")
            .flatMap(Double.init)
            .map { Date(timeIntervalSince1970: $0) }
        return GitHubRateLimit(limit: limit, remaining: remaining, resetAt: resetAt)
    }
}
