//
//  SearchRepositoriesServiceTests.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/15.
//

import Foundation
import Quick
import Nimble
@testable import GithubSearch

final class SearchRepositoriesServiceTests: QuickSpec {
    override class func spec() {
        describe("SearchRepositoriesService") {
            it("builds correct URL & headers") {
                let captured = CaptureRef<URLRequest?>(nil)
                let body = #"{"total_count":0,"items":[]}"#.data(using: .utf8)!
                let client = HTTPClientStub { req in
                    captured.set(req)
                    return (body, .http(url: req.url!, status: 200, headers: ["X-RateLimit-Remaining":"10"]))
                }
                let svc = SearchRepositoriesService(client: client)

                waitUntil(timeout: .seconds(1)) { done in
                    Task {
                        _ = try? await svc.searchRepositories(.init(
                            query: "swift", language: "Swift",
                            sort: .stars, order: .desc,
                            page: 1, perPage: 30
                        ))
                        done()
                    }
                }

                let url = captured.get()!.url!.absoluteString
                expect(url).to(contain("/search/repositories"))
                expect(url).to(contain("q=swift%20language:Swift"))
                expect(url).to(contain("sort=stars"))
                expect(url).to(contain("order=desc"))
                expect(url).to(contain("page=1"))
                expect(url).to(contain("per_page=30"))

                let req = captured.get()!
                expect(req.value(forHTTPHeaderField: "Accept"))
                    .to(equal("application/vnd.github+json"))
                expect(req.value(forHTTPHeaderField: "X-GitHub-Api-Version"))
                    .to(equal("2022-11-28"))
            }

            it("throws rateLimited on 403") {
                let client = HTTPClientStub { req in
                    let body = #"{"message":"API rate limit exceeded"}"#.data(using: .utf8)!
                    return (body, .http(url: req.url!, status: 403,
                        headers: ["X-RateLimit-Remaining":"0","X-RateLimit-Reset":"9999999999"]))
                }
                let svc = SearchRepositoriesService(client: client)

                var caught: Error?
                waitUntil(timeout: .seconds(1)) { done in
                    Task {
                        do {
                            _ = try await svc.searchRepositories(.init(
                                query: "swift", language: nil, sort: nil, order: nil, page: 1, perPage: 10
                            ))
                        } catch { caught = error }
                        done()
                    }
                }

                expect(caught).toNot(beNil())
                if let err = caught {
                    if case SearchRepositoriesServiceError.rateLimited = err { /* OK */ }
                    else { fail("expected rateLimited, got \(err)") }
                } else {
                    fail("no error thrown")
                }
            }
        }
    }
}
