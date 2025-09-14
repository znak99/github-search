//
//  SearchRepositoriesHeader.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct SearchRepositoriesHeader: View {
    var body: some View {
        VStack {
            HStack {
                AppIcon(icon: "github", size: 40)
                Spacer()
                HStack(spacing: 24) {
                    NavigationLink(destination: EmptyView()) {
                        AppIcon(icon: "bookmark", size: 24)
                    }
                    Button(action: {}, label: {
                        AppIcon(icon: "menu", size: 24)
                    })
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    SearchRepositoriesHeader()
}
