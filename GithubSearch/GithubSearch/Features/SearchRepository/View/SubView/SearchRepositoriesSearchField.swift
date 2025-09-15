//
//  SearchRepositoriesSearchField.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// 検索用のテキストフィールドビュー
struct SearchRepositoriesSearchField: View {
    
    @Binding var text: String
    let onSearch: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                SquareAppIcon(icon: "search", size: 20)
                
                Text("レポジトリ検索")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding(.top)
            
            TextField("キーワード", text: $text)
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.surface)
                }
                .onSubmit {
                    onSearch()
                }
        }
    }
}

#Preview {
    SearchRepositoriesSearchField(text: .constant("keyword")) {}
}
