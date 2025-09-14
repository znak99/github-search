//
//  SearchRepositoriesSearchField.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct SearchRepositoriesSearchField: View {
    
    @Binding var text: String
    let onSearch: () -> Void
    
    var body: some View {
        VStack {
            Text("レポジトリ検索")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            HStack {
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
                Button(action: onSearch, label: {
                    AppIconFrame(icon: "search", size: 24)
                })
                .padding(4)
            }
        }
    }
}

#Preview {
    SearchRepositoriesSearchField(text: .constant("keyword")) {}
}
