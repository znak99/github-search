//
//  UIApplication+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// UIApplication拡張: キーボードを閉じるための機能
extension UIApplication {
    func hideKeyboard() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
