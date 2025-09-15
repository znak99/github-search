//
//  SearchRepositoriesMenu.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/15.
//

import SwiftUI

// 検索メニュー (ソート・言語フィルターなどを表示)
struct SearchRepositoriesMenu: View {
    let limit: Int?
    @Binding var sort: SearchRepositoriesSort?
    @Binding var order: SearchRepositoriesOrder?
    @Binding var language: String?
    @Binding var isShowLanguagePicker: Bool
    
    var body: some View {
        VStack {
            if let limit {
                Text("検索制限残り\(limit)回")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            SearchRepositoriesSortSection(sort: $sort, order: $order)
            
            VStack {
                HStack(spacing: 4) {
                    SquareAppIcon(icon: "code", size: 12)
                    Text("レポジトリ言語")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                
                Text(language ?? "指定なし")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(language == nil ? .secondary : .primary)
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .onTapGesture {
                isShowLanguagePicker = true
            }
        }
    }
}

#Preview {
    SearchRepositoriesMenu(
        limit: 5,
        sort: .constant(.forks),
        order: .constant(.asc),
        language: .constant(nil),
        isShowLanguagePicker: .constant(false))
}
