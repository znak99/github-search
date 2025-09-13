//
//  SearchRepositoriesView.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import SwiftUI

struct SearchRepositoriesView: View {
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
            // Header
            VStack {
                HStack {
                    Image("github")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            minWidth: 36, idealWidth: 40, maxWidth: 44,
                            minHeight: 36, idealHeight: 40, maxHeight: 44)
                    Spacer()
                    HStack(spacing: 24) {
                        Image("bookmark")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                minWidth: 20, idealWidth: 24, maxWidth: 28,
                                minHeight: 20, idealHeight: 24, maxHeight: 28)
                        Image("menu")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                minWidth: 20, idealWidth: 24, maxWidth: 28,
                                minHeight: 20, idealHeight: 24, maxHeight: 28)
                    }
                }
            }
            .padding([.top, .horizontal])
            
            // Search field/options
            VStack {
                Text("レポジトリ検索")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                HStack {
                    TextField("キーワードを入力してください", text: $searchText)
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.surface)
                        }
                    Button(action: {}, label: {
                        Image("search")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                minWidth: 20, idealWidth: 24, maxWidth: 28,
                                minHeight: 20, idealHeight: 24, maxHeight: 28)
                    })
                    .padding(4)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    SearchRepositoriesView()
}
