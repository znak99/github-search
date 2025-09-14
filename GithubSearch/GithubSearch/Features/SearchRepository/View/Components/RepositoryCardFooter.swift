//
//  RepositoryCardFooter.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct RepositoryCardFooter: View {
    
    var body: some View {
        HStack {
            Text("詳しく見る")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            Spacer()
            SquareAppIcon(icon: "angle-right", size: 24)
        }
    }
}
