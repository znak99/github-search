//
//  GithubSearchApp.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import SwiftUI

@main
struct GithubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SearchRepositoriesView()
                    .overlay(KeyboardWarmup().frame(width: 0, height: 0))
            }
        }
    }
}
