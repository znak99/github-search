//
//  SearchRepositoriesView.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/13.
//

import SwiftUI

// レポジトリ検索画面（単一画面構成のルートビュー）
struct SearchRepositoriesView: View {
    @StateObject private var vm = SearchRepositoriesViewModel(
        usecase: SearchRepositoriesInteractor(
            service: SearchRepositoriesService()
        )
    )
    
    var body: some View {
        ZStack {
            VStack {
                // ヘッダー部分
                SearchRepositoriesHeader(
                    isShowMenu: $vm.isShowMenu,
                    isShowLanguagePicker: $vm.isShowLanguagePicker
                )
                
                // 検索オプションメニュー
                if vm.isShowMenu {
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
                        )
                    )
                }
                
                // 検索入力フィールド
                SearchRepositoriesSearchField(
                    text: Binding(
                        get: { vm.state.query },
                        set: { newValue in
                            if vm.state.query != newValue { vm.send(.setQuery(newValue)) }
                        }
                    ),
                    onSearch: { vm.send(.submit) }
                )
                
                // 状態ごとの表示切り替え
                switch vm.state.viewState {
                case .idle:
                    // 初期状態
                    SearchRepositoriesStateMessage(
                        main: "気になるテーマは？",
                        sub: "キーワードを入力してください"
                    )
                    
                case .empty:
                    // 検索結果なし
                    SearchRepositoriesStateMessage(
                        main: "レポジトリが見つかりません",
                        sub: "条件を変えて検索してください"
                    )
                    
                case .loaded:
                    // 検索結果リスト
                    SearchRepositoriesResultInfo(count: vm.state.items.count)
                    
                    SearchRepositoriesList(
                        repos: vm.state.items,
                        isLoadingNext: vm.state.isLoadingNext,
                        canLoadMore: vm.state.canLoadMore,
                        loadMore: { id in
                            vm.send(.reachedBottom(currentID: id))
                        },
                        onSelect: { _ in
                            // TODO: - ADD DETAIL VIEW
                        }
                    )
                    
                case .loading:
                    // ローディング中
                    RepositorySkeleton()
                    
                case .error(let msg):
                    // エラー表示
                    SearchRepositoriesStateMessage(
                        main: "検索エラー",
                        sub: msg
                    )
                }
            }
            .padding(.horizontal)
            .dismissKeyboardOnTap()
            .sheet(isPresented: $vm.isShowLanguagePicker) { // 言語選択ピッカー
                LanguageFilterSheet(vm: vm)
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    SearchRepositoriesView()
}
