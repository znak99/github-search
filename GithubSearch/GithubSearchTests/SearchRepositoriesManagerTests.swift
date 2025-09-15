//
//  SearchRepositoriesManagerTests.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/15.
//

import Foundation
import Quick
import Nimble
@testable import GithubSearch

// MARK: - Spec
final class SearchRepositoriesManagerSpec: QuickSpec {
    override class func spec() {
        var usecase: UsecaseStub!
        var manager: SearchRepositoriesManager!

        beforeEach {
            usecase = UsecaseStub()
            manager = SearchRepositoriesManager(usecase: usecase)
        }

        // 1) 디바운스 후 1회만 발사
        it("debouncedFirstPage fires once after delay") {
            let state = makeState(query: "swift")
            var willFireCount = 0
            var resultCount = 0

            waitUntil(timeout: .seconds(2)) { done in
                Task {
                    await manager.debouncedFirstPage(
                        snapshot: state,
                        delayMs: 20,
                        onWillFire: { willFireCount += 1 },
                        onResult: { _, _, _ in resultCount += 1; done() },
                        onError: { _ in fail("should not error") }
                    )
                }
            }

            expect(willFireCount) == 1
            expect(resultCount) == 1
        }

        // 2) cancelDebounce가 차단
        it("cancelDebounce prevents firing") {
            let state = makeState(query: "swift")
            var fired = false

            Task {
                await manager.debouncedFirstPage(
                    snapshot: state,
                    delayMs: 50,
                    onWillFire: { fired = true },
                    onResult: { _, _, _ in },
                    onError: { _ in }
                )
            }
            Task { await manager.cancelDebounce() }

            Thread.sleep(forTimeInterval: 0.1) // 충분히 대기
            expect(fired) == false
        }

        // 3) 새 요청 오면 이전 currentTask 취소
        it("cancels previous in-flight task when a new one starts") {
            let state1 = makeState(query: "swift", page: 1)
            let state2 = makeState(query: "swift", page: 2)

            usecase.delayMs = 80 // 첫 호출은 느리게

            var firstCalled = false
            var secondCalled = false

            waitUntil(timeout: .seconds(2)) { done in
                Task {
                    await manager.loadFirstPage(
                        snapshot: state1,
                        onResult: { _, _, _ in firstCalled = true },
                        onError: { _ in }
                    )
                }

                // 조금 기다렸다 두번째 호출
                Task {
                    try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
                    usecase.delayMs = 0
                    await manager.loadMore(
                        snapshot: state2,
                        onResult: { _, _, _ in
                            secondCalled = true
                            done()
                        },
                        onError: { _ in }
                    )
                }
            }

            expect(firstCalled) == false
            expect(secondCalled) == true
        }

        // 4) 에러 시 onError가 메인스레드에서 호출
        it("calls onError on main actor when usecase throws") {
            struct Dummy: Error {}
            usecase.result = .failure(Dummy())

            let state = makeState(query: "swift")
            var gotError = false
            var isMainThread = false

            waitUntil(timeout: .seconds(2)) { done in
                Task {
                    await manager.loadFirstPage(
                        snapshot: state,
                        onResult: { _, _, _ in fail("should not success") },
                        onError: { _ in
                            gotError = true
                            isMainThread = Thread.isMainThread
                            done()
                        }
                    )
                }
            }

            expect(gotError) == true
            expect(isMainThread) == true
        }
    }
}

// MARK: - Usecase Stub
final private class UsecaseStub: SearchRepositoriesUsecase, @unchecked Sendable {
    var delayMs: Int = 0
    var result: Result<(SearchRepositoriesResponse, GitHubRateLimit), Error> =
        .success((.init(totalCount: 0, incompleteResults: false, items: []),
                  .init(limit: 10, remaining: 10, resetAt: Date())))
    var lastParams: (q: String, lang: String?, sort: SearchRepositoriesSort?, order: SearchRepositoriesOrder?, page: Int, per: Int)?

    func execute(
        query: String,
        language: String?,
        sort: SearchRepositoriesSort?,
        order: SearchRepositoriesOrder?,
        page: Int,
        perPage: Int
    ) async throws -> (SearchRepositoriesResponse, GitHubRateLimit) {
        lastParams = (query, language, sort, order, page, perPage)
        if delayMs > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
        }
        switch result {
        case .success(let v): return v
        case .failure(let e): throw e
        }
    }
}

// MARK: - State Helper
private func makeState(
    query: String = "swift",
    language: String? = nil,
    sort: SearchRepositoriesSort? = nil,
    order: SearchRepositoriesOrder? = nil,
    page: Int = 1
) -> SearchRepositoryState {
    var s = SearchRepositoryState()
    s.query = query
    s.language = language
    s.sort = sort
    s.order = order
    s.page = page
    return s
}
