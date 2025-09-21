//
//  SearchRepositoriesList.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// リポジトリ一覧を表示するビュー
struct SearchRepositoriesList: View {
    
    let repos: [GitHubRepository]
    let isLoadingNext: Bool
    let canLoadMore: Bool
    let loadMore: (Int?) -> Void
    var onSelect: (GitHubRepository) -> Void = { _ in }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(repos, id: \.id) { repo in
                    RepositoryCard(repo: repo)
                        .onAppear {
                            // 最後のセルが表示されたら次のページをロードする
                            if repo.id == repos.last?.id, canLoadMore, !isLoadingNext {
                                loadMore(repo.id)
                            }
                        }
                        .onTapGesture {
                            onSelect(repo)
                        }
                }
                
                if isLoadingNext {
                    ProgressView()
                        .padding(.vertical, 16)
                }
            }
        }
    }
}

#Preview {
    SearchRepositoriesList(
        repos: [],
        isLoadingNext: false,
        canLoadMore: false,
        loadMore: {_ in },
        onSelect: {_ in })
}
