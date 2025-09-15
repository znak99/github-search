//
//  SearchRepositoriesUsecaseTests.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/15.
//

import Foundation
import Quick
import Nimble
@testable import GithubSearch

final class SearchRepositoriesInteractorSpec: QuickSpec {
    override class func spec() {
        var service: MockSearchRepositoriesService!
        var sut: SearchRepositoriesInteractor!
        
        beforeEach {
            service = MockSearchRepositoriesService()
            sut = SearchRepositoriesInteractor(service: service)
        }
        
        describe("execute") {
            context("when query is empty") {
                it("throws emptyQuery error") {
                    waitUntil { done in
                        Task {
                            do {
                                _ = try await sut.execute(
                                    query: "   ",
                                    language: nil,
                                    sort: nil,
                                    order: nil,
                                    page: 1,
                                    perPage: 30
                                )
                                fail("Should have thrown emptyQuery error")
                            } catch let error as SearchRepositoriesUseCaseError {
                                expect(error).to(equal(.emptyQuery))
                            } catch {
                                fail("Unexpected error: \(error)")
                            }
                            done()
                        }
                    }
                }
                
            }
            
            context("when valid query is given") {
                it("normalizes language and clamps page/perPage") {
                    waitUntil { done in
                        Task {
                            do {
                                _ = try await sut.execute(
                                    query: "swift ",
                                    language: "  ",
                                    sort: nil,
                                    order: .desc,
                                    page: -5,
                                    perPage: 500
                                )
                                
                                expect(service.lastRequest).toNot(beNil())
                                expect(service.lastRequest?.query) == "swift"
                                expect(service.lastRequest?.language).to(beNil()) // trimmed → nil
                                expect(service.lastRequest?.page) == 1            // clamped
                                expect(service.lastRequest?.perPage) == 100       // clamped
                                expect(service.lastRequest?.sort).to(beNil())
                                expect(service.lastRequest?.order).to(beNil())    // sort nil → order nil
                            } catch {
                                fail("Unexpected error: \(error)")
                            }
                            done()
                        }
                    }
                }
                
            }
        }
    }
}

// MARK: - Mock
final class MockSearchRepositoriesService: SearchRepositoriesServicing, @unchecked Sendable {
    var lastRequest: SearchRepositoriesRequest?
    
    func searchRepositories(_ req: SearchRepositoriesRequest) async throws -> (SearchRepositoriesResponse, GitHubRateLimit) {
        self.lastRequest = req
        // 더미 응답
        return (
            SearchRepositoriesResponse(totalCount: 0, incompleteResults: false, items: []),
            GitHubRateLimit(limit: 10, remaining: 10, resetAt: Date())
        )
    }
}
