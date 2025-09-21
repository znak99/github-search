//
//  RepositoryCardHeader.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI
import Shimmer

// リポジトリカードのヘッダー部分を表示するビュー
struct RepositoryCardHeader: View {
    
    let repo: GitHubRepository
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AsyncImage(url: repo.owner.avatarURL) { phase in
                switch phase {
                case .empty:
                    Image("github-avatar")
                        .avatarSize(48)
                        .background {
                            Circle().fill(.secondary)
                        }
                        .shimmering()
                    
                case .success(let image):
                    image.avatarSize(48).clipShape(Circle())
                    
                case .failure(_):
                    Image("github").avatarSize(48)
                    
                @unknown default:
                    Image("github").avatarSize(48)
                }
            }
            
            VStack(alignment: .leading) {
                Text(repo.owner.login)
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .underline()
                
                Text(repo.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("最終更新日 \(repo.updatedAt.formatted())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack {
                    SquareAppIcon(icon: "code", size: 20)
                    
                    Text(repo.language ?? "Unknown")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}
