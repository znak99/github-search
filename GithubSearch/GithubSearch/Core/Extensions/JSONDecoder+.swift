//
//  JSONDecoder+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

// GitHub API の日付フォーマット対応用 JSONDecoder 拡張
extension JSONDecoder {
    
    static var github: JSONDecoder {
        let decoder = JSONDecoder()
        
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        // GitHub の日時はミリ秒ありとなしが混在するので、まずミリ秒ありを試す
        
        decoder.dateDecodingStrategy = .custom { dec in
            let str = try dec.singleValueContainer().decode(String.self)
            
            if let date = fmt.date(from: str) {
                return date
            }
            
            let fallback = ISO8601DateFormatter()
            fallback.formatOptions = [.withInternetDateTime]
            
            if let date = fallback.date(from: str) {
                return date
            }
            
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: dec.codingPath,
                    debugDescription: "Invalid date: \(str)"
                )
            )
        }
        
        return decoder
    }
}
