//
//  SearchRepositoriesStateMessage.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// 検索結果が空やエラーのときに表示するメッセージビュー
struct SearchRepositoriesStateMessage: View {
    let main: String
    let sub: String
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text(main)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text(sub)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
}
