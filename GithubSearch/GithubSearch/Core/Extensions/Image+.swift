//
//  Image+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// プロフィール画像などを正方形で表示する拡張
extension Image {
    func avatarSize(_ size: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .squareFrame(size, range: 8)
    }
}
