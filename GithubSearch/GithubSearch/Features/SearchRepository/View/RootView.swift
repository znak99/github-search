//
//  RootView.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/12.
//

import SwiftUI

struct RootView: View {
    @StateObject private var vm = SearchRepositoriesViewModel(
        usecase: SearchRepositoriesInteractor(
            service: SearchRepositoriesService() // 실제 서비스
        )
    )
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
                        NavigationLink(destination: EmptyView()) {
                            Image("bookmark")
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    minWidth: 20, idealWidth: 24, maxWidth: 28,
                                    minHeight: 20, idealHeight: 24, maxHeight: 28)
                        }
                        Button(action: {}, label: {
                            Image("menu")
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    minWidth: 20, idealWidth: 24, maxWidth: 28,
                                    minHeight: 20, idealHeight: 24, maxHeight: 28)
                        })
                    }
                }
            }
            .padding(.top)
            
            ScrollView {
                // Search field/options
                VStack {
                    Text("レポジトリ検索")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                    HStack {
                        TextField("キーワードを入力してください", text: Binding(
                            get: { vm.state.query},
                            set: { vm.send(.setQuery($0)) }
                        ))
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundStyle(.primary)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.surface)
                            }
                        Button(action: {
                            vm.send(.submit)
                        }, label: {
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
                
                // Search result info
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
                
                ForEach(vm.state.items, id: \.id) { repo in
                    VStack {
                        // header
                        HStack(alignment: .top, spacing: 8) {
                            AsyncImage(url: repo.owner.avatarURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48, alignment: .center)
                                        .clipShape(Circle())
                                case .failure(_):
                                    Image("github")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48, alignment: .center)
                                        .clipShape(Circle())
                                @unknown default:
                                    Image("github")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48, alignment: .center)
                                        .clipShape(Circle())
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
                                Text("最終更新日 \(formatDate(repo.updatedAt))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    Image("code")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            minWidth: 16, idealWidth: 20, maxWidth: 24,
                                            minHeight: 16, idealHeight: 20, maxHeight: 24)
                                    Text(repo.language ?? "Unknown")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                        
                        // body
                        VStack {
                            HStack {
                                HStack {
                                    Image("star")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            minWidth: 12, idealWidth: 16, maxWidth: 20,
                                            minHeight: 12, idealHeight: 16, maxHeight: 20)
                                    Text("\(repo.stargazersCount) Stars")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                HStack {
                                    Image("fork")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            minWidth: 12, idealWidth: 16, maxWidth: 20,
                                            minHeight: 12, idealHeight: 16, maxHeight: 20)
                                    Text("\(repo.forksCount) Forks")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                            }
                            if let description = repo.description {
                                VStack {
                                    Text("レポジトリ説明")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(description)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Divider()
                            HStack {
                                Text("詳しく見る")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.surface)
                    }
                    .onTapGesture {
                        print(repo.name)
                    }
                    .onAppear {
                        vm.send(.reachedBottom(currentID: repo.id))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

#Preview {
    RootView()
}
