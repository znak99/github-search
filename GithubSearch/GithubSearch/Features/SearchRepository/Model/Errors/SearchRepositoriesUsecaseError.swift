//
//  SearchRepositoriesUsecaseError.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHubリポジトリ検索ユースケースで発生するエラー定義
public enum SearchRepositoriesUseCaseError: Error, Sendable {
    case emptyQuery
}
