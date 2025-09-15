//
//  SearchRepositoriesSortSection.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/15.
//

import SwiftUI

// リポジトリ検索の並び順セクションビュー
struct SearchRepositoriesSortSection: View {
    
    @Binding var sort: SearchRepositoriesSort?
    @Binding var order: SearchRepositoriesOrder?
    
    var body: some View {
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
                sortState: $sort,
                orderState: $order
            )
            RepositorySortButton(
                icon: "fork",
                text: "Forks",
                sort: .forks,
                sortState: $sort,
                orderState: $order
            )
            RepositorySortButton(
                icon: "clock",
                text: "Date",
                sort: .updated,
                sortState: $sort,
                orderState: $order
            )
        }
        
        if let orderState = order {
            Button(
                action: { order = (orderState == .asc ? .desc : .asc) },
                label: {
                    HStack {
                        Spacer()
                        SquareAppIcon(
                            icon: order == .asc ? "order-up" : "order-down",
                            size: 12
                        )
                        Text(order == .asc ? "昇順" : "降順")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundStyle(.reverse)
                        Spacer()
                    }
                }
            )
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.primary)
            }
        }
    }
}
