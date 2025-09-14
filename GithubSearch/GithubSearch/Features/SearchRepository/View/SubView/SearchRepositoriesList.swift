//
//  SearchRepositoriesList.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

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
                    // Repository Card
                    RepositoryCard(repo: repo)
                        .onAppear {
                            if repo.id == repos.last?.id, canLoadMore, !isLoadingNext {
                                loadMore(repo.id)
                            }
                        }
                        .onTapGesture {
                            onSelect(repo)
                        }
                }
                if isLoadingNext {
                    ProgressView().padding(.vertical, 16)
                }
            }
        }
    }
}

#Preview {
    SearchRepositoriesList(
        repos: testRepos,
        isLoadingNext: false,
        canLoadMore: false,
        loadMore: {_ in },
        onSelect: {_ in })
}
