//
//  RepositorySortButton.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/15.
//

import SwiftUI

struct RepositorySortButton: View {
    let icon: String
    let text: String
    let sort: SearchRepositoriesSort
    @Binding var sortState: SearchRepositoriesSort?
    @Binding var orderState: SearchRepositoriesOrder?

    var body: some View {
        Button {
            sortState = (sortState == sort ? nil : sort)
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

