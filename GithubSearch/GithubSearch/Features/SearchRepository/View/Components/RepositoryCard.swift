//
//  RepositoryCard.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// リポジトリ情報を表示するカード
struct RepositoryCard: View {
    
    let repo: GitHubRepository
    
    var body: some View {
        VStack {
            RepositoryCardHeader(repo: repo)
            RepositoryCardBody(repo: repo)
            Divider()
            RepositoryCardFooter()
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.surface)
        }
        .padding(.bottom)
    }
}

