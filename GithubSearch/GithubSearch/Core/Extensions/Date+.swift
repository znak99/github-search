//
//  Date+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import Foundation

// 日付を共通フォーマットで文字列に変換する拡張
extension Date {
    func formatted() -> String {
        Date.cachedFormatter.string(from: self)
    }
    
    private static let cachedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
}
