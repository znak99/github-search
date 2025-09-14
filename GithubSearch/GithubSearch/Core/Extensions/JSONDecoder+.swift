//
//  JSONDecoder+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

/// GitHub API の日付フォーマット対応用 JSONDecoder 拡張
/// - GitHub の日時文字列は「ミリ秒あり」「ミリ秒なし」の両方が混在する場合があるので
/// - ISO8601DateFormatter を用いてミリ秒ありを試し、失敗したらミリ秒なしで再度パースする
extension JSONDecoder {
    static var github: JSONDecoder {
        let decoder = JSONDecoder()
        
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // [yyyy-MM-dd'T'HH:mm:ssZ, yyyy-MM-dd'T'HH:mm:ss.SSSZ]
        
        decoder.dateDecodingStrategy = .custom { dec in
            let str = try dec.singleValueContainer().decode(String.self)
            
            if let date = fmt.date(from: str) { return date }
            
            let fallback = ISO8601DateFormatter()
            fallback.formatOptions = [.withInternetDateTime]
            
            if let date = fallback.date(from: str) { return date }
            
            // Error
            throw DecodingError.dataCorrupted(.init(codingPath: dec.codingPath,debugDescription: "Invalid date: \(str)"))
        }
        return decoder
    }
}
