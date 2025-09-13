//
//  RootView.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import SwiftUI

struct RootView: View {
    @State private var repos: [GitHubRepository] = []
    @State private var errorMessage: String?
    var body: some View {
        NavigationView {
            List {
                if let errorMessage {
                    Text("에러: \(errorMessage)")
                } else {
                    ForEach(repos) { repo in
                        VStack(alignment: .leading) {
                            Text(repo.fullName)
                                .font(.headline)
                            Text(repo.description ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("검색 결과")
            .refreshable {
                Task {
                    await fetch()
                }
            }
        }
        .onAppear {
            Task {
                await fetch()
            }
        }
    }
    
    private func fetch() async {
        guard let service = SearchRepositoriesService() else {
            errorMessage = "Service 초기화 실패"
            return
        }
        let req = SearchRepositoriesRequest(
            query: "swiftui",
            language: "Python",
            sort: .stars,
            order: .desc,
            page: 1,
            perPage: 10
        )
        do {
            let (res, rate) = try await service.searchRepositories(req)
            repos = res.items
            print("Rate Limit 남은 횟수: \(rate.remaining ?? -1)")
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    RootView()
}
