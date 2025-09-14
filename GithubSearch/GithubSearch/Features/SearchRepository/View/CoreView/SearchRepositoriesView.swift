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
            SearchRepositoriesList(repos: vm.state.items)
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchRepositoriesView()
}
