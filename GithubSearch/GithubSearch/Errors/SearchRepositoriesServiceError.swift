//
//  SearchRepositoriesServiceError.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

public enum SearchRepositoriesServiceError: Error, LocalizedError, Sendable {
    case invalidQuery
    case httpStatus(Int, String?)
    case rateLimited(resetAt: Date?)
    case decoding(Error)
    case transport(Error)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidQuery: 
            return "検索クエリが無効です。"
        case .httpStatus(let code, let msg):
            return "HTTP \(code): \(msg ?? "エラー")"
        case .rateLimited(let reset):
            return "レート制限。再試行: \(reset?.description ?? "後で")"
        case .decoding:
            return "レスポンス解析に失敗。"
        case .transport: 
            return "ネットワークエラー。"
        case .unknown: 
            return "不明なエラー。"
        }
    }
}
