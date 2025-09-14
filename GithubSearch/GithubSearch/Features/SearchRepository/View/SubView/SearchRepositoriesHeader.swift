//
//  SearchRepositoriesHeader.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct SearchRepositoriesHeader: View {
    
    @Binding var isShowMenu: Bool
    
    var body: some View {
        VStack {
            HStack {
                SquareAppIcon(icon: "github", size: 40)
                Spacer()
                HStack(spacing: 24) {
                    NavigationLink(destination: EmptyView()) {
                        SquareAppIcon(icon: "bookmark", size: 20)
                    }
                    Button(action: {
                        withAnimation {
                            isShowMenu.toggle()
                        }
                    }, label: {
                        SquareAppIcon(icon: isShowMenu ? "close" : "menu", size: 20)
                    })
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    SearchRepositoriesHeader(isShowMenu: .constant(false))
}
