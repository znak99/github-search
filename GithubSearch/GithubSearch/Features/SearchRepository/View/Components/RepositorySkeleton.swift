//
//  RepositorySkeleton.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI
import Shimmer

struct RepositorySkeleton: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Circle().fill(.secondary)
                    Image("github-avatar")
                        .resizable()
                        .scaledToFit()
                }
                .squareFrame(40, range: 4)
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.secondary)
                        .frame(width: 50, height: 12)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.secondary)
                        .frame(width: 100, height: 12)
                }
                Spacer()
            }
            RoundedRectangle(cornerRadius: 4)
                .fill(.secondary)
                .frame(width: 250, height: 12)
            RoundedRectangle(cornerRadius: 4)
                .fill(.secondary)
                .frame(width: 200, height: 12)
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.surface)
        }
        .shimmering()
    }
}

#Preview {
    RepositorySkeleton()
}
