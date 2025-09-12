//
//  GitHubRepository.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

struct GitHubRepository: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let htmlURL: URL
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
    let updatedAt: Date
    let owner: GitHubRepositoryOwner

    private enum CodingKeys: String, CodingKey {
        case id, name, owner, description, language
        case fullName = "full_name"
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case updatedAt = "updated_at"
    }
}
