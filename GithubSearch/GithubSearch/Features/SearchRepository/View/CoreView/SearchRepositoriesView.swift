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
                SearchRepositoriesHeader(isShowMenu: $vm.isShowMenu)
                
                if vm.isShowMenu {
                    // Menu
                    VStack {
                        if let rateLimit = vm.state.rateLimit {
                            Text("検索制限残り\(String(describing: rateLimit.limit))回")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        HStack(spacing: 4) {
                            SquareAppIcon(icon: "number-list", size: 12)
                            Text("並び順")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            RepositorySortButton(
                                icon: "star",
                                text: "Stars",
                                sort: .stars,
                                sortState: Binding(
                                    get: { vm.state.sort },
                                    set: { sort in vm.send(.setSort(sort)) }),
                                orderState: Binding(
                                    get: { vm.state.order },
                                    set: { order in vm.send(.setOrder(order)) })
                            )
                            RepositorySortButton(
                                icon: "fork",
                                text: "Forks",
                                sort: .forks,
                                sortState: Binding(
                                    get: { vm.state.sort },
                                    set: { sort in vm.send(.setSort(sort)) }),
                                orderState: Binding(
                                    get: { vm.state.order },
                                    set: { order in vm.send(.setOrder(order)) })
                            )
                            RepositorySortButton(
                                icon: "clock",
                                text: "Date",
                                sort: .updated,
                                sortState: Binding(
                                    get: { vm.state.sort },
                                    set: { sort in vm.send(.setSort(sort)) }),
                                orderState: Binding(
                                    get: { vm.state.order },
                                    set: { order in vm.send(.setOrder(order)) })
                            )
                        }
                        if let order = vm.state.order {
                            Button(
                                action: {
                                    vm.send(.setOrder(
                                        order == .asc ? .desc : .asc
                                    ))
                                },
                                label: {
                                    HStack {
                                        Spacer()
                                        SquareAppIcon(icon: order == .asc ? "order-up" : "order-down",
                                                      size: 12)
                                        Text(order == .asc ? "昇順" : "降順")
                                            .font(.callout)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.reverse)
                                        Spacer()
                                }
                            })
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.primary)
                            }
                        }
                    }
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
                        sub: "別のキーワードで検索してください"
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
        }
    }
}

#Preview {
    SearchRepositoriesView()
}
