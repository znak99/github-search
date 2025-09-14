//
//  SearchRepositoriesServiceError.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import Foundation

/// GitHub リポジトリを検索するサービスで発生するエラー
public enum SearchRepositoriesServiceError: Error, LocalizedError, Sendable {
    case invalidQuery
    case invalidURL
    case httpStatus(Int, String?)
    case rateLimited(resetAt: Date?)
    case decoding(Error)
    case transport(Error)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidQuery:
            return "検索クエリが正しくないようです\nご確認ください"
        case .invalidURL:
            return "URLが正しくないようです\nご確認ください"
        case .httpStatus(let code, let msg):
            return "HTTP \(code)\n\(msg ?? "エラーが発生しました")"
        case .rateLimited(let reset):
            if let reset {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
                
                // 残りの時間を計算
                let minutes = max(1, Calendar.current.dateComponents([.minute], from: Date(), to: reset).minute ?? 0)
                
                return """
                アクセスが一時的に制限されています
                \(minutes)分後に再実行してください
                """
            } else {
                return """
                アクセスが一時的に制限されています
                しばらく後にお願いいたします
                """
            }
        case .decoding:
            return "データを読み取れませんでした\nもう一度お試しください"
        case .transport:
            return "ネットワーク接続に問題があるようです\nご確認ください"
        case .unknown:
            return "不明なエラーが発生しました\nもう一度お試しください"
        }
    }
}

