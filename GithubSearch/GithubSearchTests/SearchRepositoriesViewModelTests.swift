//
//  SearchRepositoriesViewModelTests.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/15.
//

import Foundation

import Quick
import Nimble
@testable import GithubSearch

// MARK: - Usecase Stub (쿼리에 따라 결과/지연을 제어)
final private class UsecaseStub: SearchRepositoriesUsecase, @unchecked Sendable {
    struct Plan {
        var delayMs: Int
        var response: SearchRepositoriesResponse
        var limit: GitHubRateLimit
        var error: Error?
    }
    
    // query 문자열별로 다른 계획을 반환
    var plans: [String: Plan] = [:]
    // 기본(미지정 쿼리) 플랜
    var defaultPlan = Plan(
        delayMs: 0,
        response: .init(totalCount: 0, incompleteResults: false, items: []),
        limit: .init(limit: 10, remaining: 10, resetAt: Date()),
        error: nil
    )
    
    // 최근 호출 파라미터 스파이
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
        
        let plan = plans[query] ?? defaultPlan
        if plan.delayMs > 0 {
            try? await Task.sleep(nanoseconds: UInt64(plan.delayMs) * 1_000_000)
        }
        
        if let error = plan.error {
            throw error
        }
        return (plan.response, plan.limit)
    }
}

// MARK: - Helpers
private func repo(_ id: Int, name: String = "repo-\(UUID().uuidString)") -> GitHubRepository {
    // 프로덕트 모델의 이니셜라이저에 맞춰 수정하세요.
    GitHubRepository(
        id: id,
        name: name,
        fullName: name,
        htmlURL: .init(fileURLWithPath: "owner", relativeTo: URL(string: "https://example.com")!),
        description: "desc",
        stargazersCount: 0,
        forksCount: 0,
        language: "Swift",
        updatedAt: Date(),
        owner: .init(login: "owner", avatarURL: URL(string: "https://example.com")!)
    )
}

private func response(items: [GitHubRepository], total: Int? = nil) -> SearchRepositoriesResponse {
    .init(totalCount: total ?? items.count, incompleteResults: false, items: items)
}

private func limit(remaining: Int = 10) -> GitHubRateLimit {
    .init(limit: 10, remaining: remaining, resetAt: Date())
}

// MARK: - Spec
final class SearchRepositoriesViewModelSpec: QuickSpec {
    override class func spec() {
        var usecase: UsecaseStub!
        var vm: SearchRepositoriesViewModel!
        
        beforeEach {
            usecase = UsecaseStub()
            vm = SearchRepositoriesViewModel(usecase: usecase)
        }
        
        // ========== 1) submit: 즉시 검색 ==========
        it("performs immediate search on .submit and applies results") {
            // given
            let items = [repo(1, name: "swift-a"), repo(2, name: "swift-b")]
            usecase.plans["swift"] = .init(
                delayMs: 0,
                response: response(items: items, total: 100),
                limit: limit(remaining: 9),
                error: nil
            )
            
            // when: 쿼리 세팅 → submit
            vm.send(.setQuery("swift"))
            waitUntil(timeout: .seconds(2)) { done in
                Task {
                    vm.send(.submit)
                    // 결과 적용될 때까지 폴링
                    // (state는 @Published지만 여기서는 간단히 sleep-poll)
                    var tries = 0
                    while vm.state.items.isEmpty && tries < 20 {
                        try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
                        tries += 1
                    }
                    expect(vm.state.items.count) == items.count
                    expect(vm.state.page) == 1
                    expect(vm.state.rateLimit?.remaining) == 9
                    done()
                }
            }
        }
        
        // ========== 2) 디바운스 검색 ==========
        it("debounces input changes and searches after ~600ms") {
            // given
            let items = [repo(10, name: "swift-x")]
            usecase.plans["swift"] = .init(
                delayMs: 0,
                response: response(items: items, total: 1),
                limit: limit(remaining: 8),
                error: nil
            )
            
            // when: setQuery만 보냄(디바운스 경로)
            vm.send(.setQuery("swift"))
            
            // then: 600ms + 알파 기다린 뒤 결과가 반영되는지 확인
            waitUntil(timeout: .seconds(2)) { done in
                Task {
                    try? await Task.sleep(nanoseconds: 700_000_000) // 700ms 대기
                    expect(vm.state.items.map(\.id)) == items.map(\.id)
                    done()
                }
            }
        }
        
        // ========== 3) stale guard: 느린 1번 vs 빠른 2번 ==========
        it("applies only the latest result when multiple requests race (stale guard)") {
            // 느린 1번 쿼리: "swift"
            usecase.plans["swift"] = .init(
                delayMs: 400, // 느리게
                response: response(items: [repo(1, name: "old")], total: 1),
                limit: limit(remaining: 7),
                error: nil
            )
            // 빠른 2번 쿼리: "swift ui"
            usecase.plans["swift ui"] = .init(
                delayMs: 0, // 빠르게
                response: response(items: [repo(2, name: "new")], total: 1),
                limit: limit(remaining: 6),
                error: nil
            )
            
            // 1) 첫 입력
            vm.send(.setQuery("swift"))
            // 2) 조금 뒤 두 번째 입력
            waitUntil(timeout: .seconds(3)) { done in
                Task {
                    try? await Task.sleep(nanoseconds: 100_000_000) // 100ms 후
                    vm.send(.setQuery("swift ui"))
                    
                    // 600ms 디바운스 + 처리 시간 감안
                    try? await Task.sleep(nanoseconds: 800_000_000)
                    
                    // 최신 쿼리("swift ui") 결과만 반영돼야 함
                    expect(vm.state.items.count) == 1
                    expect(vm.state.items.first?.name).to(contain("new"))
                    done()
                }
            }
        }
        
        // ========== 4) 페이지네이션: reachedBottom → loadNext ==========
        it("loads next page when reachedBottom is triggered at the end of the list") {
            // page 1 응답
            usecase.plans["swift"] = .init(
                delayMs: 0,
                response: response(items: [repo(100, name: "p1-a"), repo(101, name: "p1-b")], total: 4),
                limit: limit(remaining: 9),
                error: nil
            )
            
            // 1) 첫 페이지 로드
            vm.send(.setQuery("swift"))
            waitUntil(timeout: .seconds(2)) { done in
                Task {
                    vm.send(.submit)
                    // page1 적용될 때까지 대기
                    var tries = 0
                    while (vm.state.items.count < 2 || vm.state.page != 1) && tries < 50 {
                        try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
                        tries += 1
                    }
                    expect(vm.state.items.count) == 2
                    expect(vm.state.page) == 1
                    expect(vm.state.canLoadMore) == true // 총 4개라면 true여야 함
                    done()
                }
            }
            
            // 2) 다음 페이지 응답 준비(같은 쿼리지만 다른 아이템)
            usecase.plans["swift"] = .init(
                delayMs: 0,
                response: response(items: [repo(102, name: "p2-a"), repo(103, name: "p2-b")], total: 4),
                limit: limit(remaining: 8),
                error: nil
            )
            
            // 3) 마지막 아이템 id로 reachedBottom 트리거
            let lastID = vm.state.items.last?.id
            expect(lastID).toNot(beNil())
            
            waitUntil(timeout: .seconds(3)) { done in
                Task { @MainActor in
                    // 반드시 메인에서 보내기(뷰모델 메인액터)
                    vm.send(.reachedBottom(currentID: lastID))
                }
                
                Task {
                    // page2 적용될 때까지 대기
                    var tries = 0
                    while (vm.state.items.count < 4 || vm.state.page != 2 || vm.state.isLoadingNext) && tries < 100 {
                        try? await Task.sleep(nanoseconds: 20_000_000) // 20ms
                        tries += 1
                    }
                    expect(vm.state.items.count) == 4
                    expect(vm.state.page) == 2
                    done()
                }
            }
        }
        
    }
}
