//
//  LanguageFilterSheet.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/15.
//

import SwiftUI

// 言語フィルターを選択するシート
struct LanguageFilterSheet: View {
    @ObservedObject var vm: SearchRepositoriesViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("完了") { vm.isShowLanguagePicker = false }
                    .bold()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Picker("", selection: Binding(
                get: {
                    vm.state.language.flatMap { Language(rawValue: $0) } ?? .none
                },
                set: { newValue in
                    // GitHub API仕様上、"language"はクエリに直接含める必要がある
                    vm.send(.setLanguage(newValue == .none ? nil : newValue.rawValue))
                }
            )) {
                ForEach(Language.allCases) { lang in
                    Text(lang.rawValue).tag(lang)
                }
            }
            .pickerStyle(.wheel)
        }
    }
}

#Preview {
    LanguageFilterSheet(
        vm: .init(
            usecase: SearchRepositoriesInteractor(
                service: SearchRepositoriesService()
            )
        )
    )
}
