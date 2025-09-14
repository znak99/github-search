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
                SearchRepositoriesHeader(
                    isShowMenu: $vm.isShowMenu,
                    isShowLanguagePicker: $vm.isShowLanguagePicker
                )
                
                if vm.isShowMenu {
                    // Menu
                    SearchRepositoriesMenu(
                        limit: vm.state.rateLimit?.remaining,
                        sort: Binding(
                            get: { vm.state.sort },
                            set: { vm.send(.setSort($0)) }
                        ),
                        order: Binding(
                            get: { vm.state.order },
                            set: { vm.send(.setOrder($0)) }
                        ),
                        language: Binding(
                            get: { vm.state.language },
                            set: { vm.send(.setLanguage($0)) }
                        ),
                        isShowLanguagePicker: Binding(
                            get: { vm.isShowLanguagePicker },
                            set: { vm.isShowLanguagePicker = $0 }
                        ))
                }
                
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
                        sub: "条件を変えて検索してください"
                    )
                case .loaded:
                    // Search result info
                    SearchRepositoriesResultInfo(count: vm.state.items.count)
                    SearchRepositoriesList(
                        repos: vm.state.items,
                        isLoadingNext: vm.state.isLoadingNext,
                        canLoadMore: vm.state.canLoadMore,
                        loadMore: { id in
                            vm.send(
                                .reachedBottom(currentID: id)
                            )
                        },
                        onSelect: { repo in
                            // TODO: - get url
                        })
                case .loading:
                    RepositorySkeleton()
                case .error(let msg):
                    SearchRepositoriesStateMessage(
                        main: "検索エラー",
                        sub: msg
                    )
                }
            }
            .padding(.horizontal)
            .dismissKeyboardOnTap()
            .sheet(isPresented: $vm.isShowLanguagePicker) {
                VStack {
                    HStack {
                        Spacer()
                        Button("完了") { vm.isShowLanguagePicker = false }.bold()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    Picker("", selection: Binding(
                        get: {
                            vm.state.language.flatMap { Language(rawValue: $0) } ?? .none
                        },
                        set: { newValue in
                            vm.send(.setLanguage(newValue == .none ? nil : newValue.rawValue))
                        }
                    )) {
                        ForEach(Language.allCases) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    SearchRepositoriesView()
}
