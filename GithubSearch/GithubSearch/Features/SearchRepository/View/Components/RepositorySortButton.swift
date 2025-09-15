//
//  RepositorySortButton.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/15.
//

import SwiftUI

// ソート条件を選択するためのボタンビュー
struct RepositorySortButton: View {
    let icon: String
    let text: String
    let sort: SearchRepositoriesSort
    @Binding var sortState: SearchRepositoriesSort?
    @Binding var orderState: SearchRepositoriesOrder?
    
    var body: some View {
        Button {
            sortState = (sortState == sort ? nil : sort)
            
            // ソート対象が選ばれた時はデフォルトで昇順に設定
            withAnimation {
                orderState = (sortState == nil ? nil : .asc)
            }
        } label: {
            HStack {
                Spacer()
                SquareAppIcon(icon: icon, size: 12)
                Text(text)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(sortState == sort ? .reverse : .primary)
                Spacer()
            }
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(sortState == sort ? .primary : Color.reverse)
        }
    }
}
