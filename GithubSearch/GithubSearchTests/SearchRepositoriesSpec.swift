//
//  SearchRepositoriesSpec.swift
//  GithubSearchTests
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation
import Quick
import Nimble
@testable import GithubSearch

final class SearchRepositoriesSpec: QuickSpec {
    override class func spec() {
        describe("GitHub Search decode") {
            var response: GitHubRepositoriesResponse!
            
            context("success JSON (with/without milliseconds)") {
                beforeEach {
                    let data = try! Fixture.data(named: "SearchRepositoriesResponse_success")
                    response = try! JSONDecoder.github.decode(GitHubRepositoriesResponse.self, from: data)
                }
                
                it("parses count and flag") {
                    expect(response.totalCount) == 2
                    expect(response.incompleteResults) == false
                }
                
                it("decodes 2 items") {
                    expect(response.items.count) == 2
                }
                
                it("maps first item fields") {
                    let first = response.items[0]
                    expect(first.id) == 1
                    expect(first.name) == "TestRepo1"
                    expect(first.fullName) == "tester1/TestRepo1"
                    expect(first.htmlURL.absoluteString) == "https://github.com/tester1/TestRepo1"
                    expect(first.description) == "Sample repository"
                    expect(first.stargazersCount) == 10
                    expect(first.forksCount) == 10
                    expect(first.language) == "Swift"
                    expect(first.owner.login) == "tester1"
                    expect(first.owner.avatarURL.absoluteString)
                    == "https://avatars.githubusercontent.com/u/1?v=4"
                }
                
                it("parses updatedAt (ISO8601 withFractionalSeconds)") {
                    let first = response.items[0]
                    let comps = Calendar(identifier: .gregorian).dateComponents(in: .init(secondsFromGMT: 0)!, from: first.updatedAt)
                    expect(comps.year) == 2025
                    expect(comps.month) == 9
                    expect(comps.day) == 12
                }
                
                it("parses case without milliseconds") {
                    let second = response.items[1]
                    let comps = Calendar(identifier: .gregorian).dateComponents(in: .init(secondsFromGMT: 0)!, from: second.updatedAt)
                    expect(comps.year) == 2025
                    expect(comps.month) == 9
                    expect(comps.day) == 11
                    expect(second.description).to(beNil())
                    expect(second.language).to(beNil())
                }
            }
            
            context("invalid date format should fail") {
                it("throws DecodingError") {
                    let data = try! Fixture.data(named: "SearchRepositoriesResponse_fail")
                    
                    expect {
                        try JSONDecoder.github.decode(GitHubRepositoriesResponse.self, from: data)
                    }.to(throwError())
                }
            }
        }
    }
}
