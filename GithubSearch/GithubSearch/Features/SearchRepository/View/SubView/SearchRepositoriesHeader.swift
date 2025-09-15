//
//  SearchRepositoriesHeader.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// 検索画面のヘッダー
struct SearchRepositoriesHeader: View {
    
    @Binding var isShowMenu: Bool
    @Binding var isShowLanguagePicker: Bool
    
    var body: some View {
        VStack {
            HStack {
                SquareAppIcon(icon: "github", size: 40)
                
                Spacer()
                
                HStack(spacing: 24) {
                    NavigationLink(destination: EmptyView()) { // TODO: - ADD REPOSITORY BOOKMARK VIEW
                        SquareAppIcon(icon: "bookmark", size: 20)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isShowMenu.toggle()
                            
                            // メニューを閉じるときは言語ピッカーも閉じる
                            if !isShowMenu {
                                isShowLanguagePicker = false
                            }
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
    SearchRepositoriesHeader(isShowMenu: .constant(false), isShowLanguagePicker: .constant(false))
}
