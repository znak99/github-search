//
//  SearchRepositoriesResultInfo.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// 検索結果件数を表示するビュー
struct SearchRepositoriesResultInfo: View {
    let count: Int
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("検索結果")
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text("\(count)件")
                .font(.footnote)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
        }
        .padding(.top)
    }
}

#Preview {
    SearchRepositoriesResultInfo(count: 5)
}
