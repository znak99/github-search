//
//  SearchRepositoriesRequest.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

public struct SearchRepositoriesRequest: Sendable {
    public var query: String
    public var language: String?
    public var sort: SearchRepositoriesSort?
    public var order: SearchRepositoriesOrder?
    public var page: Int = 1
    public var perPage: Int = 20
    public init(
        query: String,
        language: String? = nil,
        sort: SearchRepositoriesSort? = nil,
        order: SearchRepositoriesOrder? = nil,
        page: Int = 1,
        perPage: Int = 20
    ) {
        self.query = query
        self.language = language
        self.sort = sort
        self.order = order
        self.page = page
        self.perPage = perPage
    }
}

public enum SearchRepositoriesSort: String, Sendable { case stars, forks, updated }
public enum SearchRepositoriesOrder: String, Sendable { case desc, asc }
