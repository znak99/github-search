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
    @State var searchText = ""
    
    var body: some View {
        ZStack {
            VStack {
                // Header
                SearchRepositoriesHeader()
                
                // Search field/options
                SearchRepositoriesSearchField(text: Binding(
                    get: { vm.state.query },
                    set: { vm.send(.setQuery($0)) }
                )) {
                    vm.send(.submit)
                }
                switch vm.state.viewState {
                case .idle:
                    Spacer()
                    Text("idle")
                    Spacer()
                case .empty:
                    Spacer()
                    Text("empty")
                    Spacer()
                case .loaded:
                    Spacer()
                    SearchRepositoriesList(repos: vm.state.items)
                    Spacer()
                case .loading:
                    Spacer()
                    Text("loading")
                    Spacer()
                case .error(let msg):
                    Spacer()
                    Text("\(msg)")
                    Spacer()
                }
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SearchRepositoriesView()
}
