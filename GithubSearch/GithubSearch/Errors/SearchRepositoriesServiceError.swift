//
//  SearchRepositoriesServiceError.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHub リポジトリ検索サービスで発生するエラー
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
            return "検索クエリが正しくないようです。ご確認ください。"
        case .httpStatus(let code, let msg):
            return "HTTP \(code): \(msg ?? "エラーが発生しました")"
        case .rateLimited(let reset):
            return "アクセスが一時的に制限されています。再試行は \(reset?.description ?? "しばらく後にお願いいたします")。"
        case .decoding:
            return "サーバーからのデータを読み取れませんでした。もう一度お試しください。"
        case .transport:
            return "ネットワーク接続に問題があるようです。ご確認ください。"
        case .unknown:
            return "不明なエラーが発生しました。もう一度お試しください。"
        }
    }
}

