//
//  URLSession+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHub API用の設定
public extension URLSession {
    static let githubDefault: URLSession = {
        let conf = URLSessionConfiguration.ephemeral // 一時的なセッション（キャッシュ、Cookieを保持しない）
        conf.waitsForConnectivity = false // ネットワーク接続を待たずに即時エラーを返す
        conf.timeoutIntervalForRequest = 15 // リクエストのタイムアウト
        conf.timeoutIntervalForResource = 30 // 全体のリソース読み込みタイムアウト
        conf.httpAdditionalHeaders = AppConfig.API.defaultHeaders
        
        return URLSession(configuration: conf)
    }()
}
