//
//  SearchRepositoriesResultInfo.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct SearchRepositoriesResultInfo: View {
    
    let repos: [GitHubRepository]
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("検索結果")
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
            Spacer()
            Text("\(repos.count)件")
                .font(.footnote)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
        }
        .padding(.top)
    }
}

#Preview {
    SearchRepositoriesResultInfo(repos: testRepos)
}
