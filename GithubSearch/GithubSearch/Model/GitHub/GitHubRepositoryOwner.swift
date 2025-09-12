//
//  GitHubRepositoryOwner.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

/// GitHub リポジトリの所有者情報
struct GitHubRepositoryOwner: Decodable, Equatable {
    let login: String
    let avatarURL: URL

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
