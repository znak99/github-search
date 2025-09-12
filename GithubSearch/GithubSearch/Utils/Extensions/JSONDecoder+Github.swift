//
//  JSONDecoder+Github.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import Foundation

extension JSONDecoder {
    static var github: JSONDecoder {
        let d = JSONDecoder()
        // GitHub는 밀리초가 붙을 수도 있음 → 커스텀 포맷터
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        d.dateDecodingStrategy = .custom { dec in
            let str = try dec.singleValueContainer().decode(String.self)
            if let date = fmt.date(from: str) { return date }
            // fallback (밀리초 없는 케이스)
            let fallback = ISO8601DateFormatter()
            fallback.formatOptions = [.withInternetDateTime]
            if let date = fallback.date(from: str) { return date }
            throw DecodingError.dataCorrupted(.init(codingPath: dec.codingPath,
                                                    debugDescription: "Invalid date: \(str)"))
        }
        return d
    }
}
