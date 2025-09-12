//
//  RootView.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                let service = SearchRepositoriesService()
                let req = SearchRepositoriesRequest(
                    query: "swift MVVM",
                    language: "Swift",
                    sort: .stars,
                    order: .desc,
                    page: 1,
                    perPage: 30
                )

                Task {
                    do {
                        let (result, rate) = try await service.searchRepositories(req)
                        print("items:", result.items.count, "remaining:", rate.remaining ?? -1)
                    } catch {
                        // 403 -> rateLimited(resetAt:) 케이스 분기하여 메시지 표시
                        print(error.localizedDescription)
                    }
                }
            }
    }
}

#Preview {
    RootView()
}
