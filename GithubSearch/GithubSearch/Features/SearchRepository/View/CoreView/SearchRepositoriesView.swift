//
//  SearchRepositoriesView.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import SwiftUI

struct SearchRepositoriesView: View {
    @StateObject private var vm = SearchRepositoriesViewModel(
        usecase: SearchRepositoriesInteractor(
            service: SearchRepositoriesService()
        )
    )
    
    var body: some View {
        ZStack {
            VStack {
                // Header
                SearchRepositoriesHeader()
                
                // Search field/options
                SearchRepositoriesSearchField(text: Binding(
                    get: { vm.state.query },
                    set: { newValue in
                        if vm.state.query != newValue { vm.send(.setQuery(newValue)) }
                    }
                )) {
                    vm.send(.submit)
                }
                switch vm.state.viewState {
                case .idle:
                    SearchRepositoriesStateMessage(
                        main: "気になるテーマは？",
                        sub: "キーワードを入力してください"
                    )
                case .empty:
                    SearchRepositoriesStateMessage(
                        main: "レポジトリが見つかりません",
                        sub: "別のキーワードで検索してください"
                    )
                case .loaded:
                    Spacer()
                    SearchRepositoriesList(repos: vm.state.items)
                    Spacer()
                case .loading:
                    Spacer()
                    Text("loading")
                    Spacer()
                case .error(let msg):
                    SearchRepositoriesStateMessage(
                        main: "検索エラー",
                        sub: msg
                    )
                }               
            }
            .padding(.horizontal)
            .dismissKeyboardOnTap()
        }
    }
}

#Preview {
    SearchRepositoriesView()
}
