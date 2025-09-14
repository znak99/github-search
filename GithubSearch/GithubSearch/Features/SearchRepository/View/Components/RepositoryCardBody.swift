//
//  RepositoryCardBody.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct RepositoryCardBody: View {
    
    let repo: GitHubRepository
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    SquareAppIcon(icon: "star", size: 16)
                    Text("\(repo.stargazersCount) Stars")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack {
                    SquareAppIcon(icon: "fork", size: 16)
                    Text("\(repo.forksCount) Forks")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            if let description = repo.description {
                Text(description)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
            }
        }
    }
}
