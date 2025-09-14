//
//  RepositoryCard.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct RepositoryCard: View {
    
    let repo: GitHubRepository
    
    var body: some View {
        VStack {
            // header
            RepositoryCardHeader(repo: repo)
            
            // body
            RepositoryCardBody(repo: repo)
            
            Divider()
            
            // footer
            RepositoryCardFooter()
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.surface)
        }
        .padding(.bottom)
        .onTapGesture {
            print(repo.name)
        }
    }
}
