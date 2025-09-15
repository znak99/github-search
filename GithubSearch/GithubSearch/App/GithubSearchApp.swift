//
//  GithubSearchApp.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import SwiftUI

// GitHub リポジトリ検索アプリのエントリーポイント
@main
struct GithubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SearchRepositoriesView()
                    // 起動直後にキーボード初回表示の遅延を防ぐためのダミービュー
                    .overlay(KeyboardWarmup().frame(width: 0, height: 0))
            }
        }
    }
}
