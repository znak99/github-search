//
//  URLSession+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

// GitHub API用のURLSession設定
public extension URLSession {
    
    static let githubDefault: URLSession = {
        let conf = URLSessionConfiguration.ephemeral
        // ネットワーク接続を待たずに即時エラーを返すため、待機は無効化
        conf.waitsForConnectivity = false
        // リクエスト単位のタイムアウト
        conf.timeoutIntervalForRequest = 15
        // リソース全体のタイムアウト
        conf.timeoutIntervalForResource = 30
        conf.httpAdditionalHeaders = AppConfig.API.defaultHeaders
        
        return URLSession(configuration: conf)
    }()
}
