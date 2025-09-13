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
    
    var body: some View {
        VStack {
            // 검색 입력
            TextField("検索ワードを入力", text: Binding(
                get: { vm.state.query },
                set: { vm.send(.setQuery($0)) }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            // 검색 버튼
            Button("検索") {
                vm.send(.submit)
            }
            .padding(.bottom)
            
            // 상태 표시
            switch vm.state.viewState {
            case .idle: Text("待機中…")
            case .loading: ProgressView()
            case .empty: Text("結果なし")
            case .error(let msg): Text("エラー: \(msg)")
            case .loaded: EmptyView()
            }
            
            // 리스트
            List(vm.state.items, id: \.id) { repo in
                VStack(alignment: .leading) {
                    Text(repo.fullName)
                        .font(.headline)
                    Text(repo.description ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .onAppear {
                    // 마지막 셀에서 더 불러오기
                    vm.send(.reachedBottom(currentID: repo.id))
                }
            }
        }
        .padding()
    }
}

#Preview {
    RootView()
}
