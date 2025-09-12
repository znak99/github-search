//
//  URLSession+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

public extension URLSession {
    static let githubDefault: URLSession = {
        let conf = URLSessionConfiguration.ephemeral
        conf.waitsForConnectivity = false
        conf.timeoutIntervalForRequest = 15
        conf.timeoutIntervalForResource = 30
        conf.httpAdditionalHeaders = [
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
        return URLSession(configuration: conf)
    }()
}
