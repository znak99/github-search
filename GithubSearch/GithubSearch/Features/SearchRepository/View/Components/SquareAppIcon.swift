//
//  AppIcon.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// 正方形アイコンを表示するビュー
struct SquareAppIcon: View {
    let icon: String
    let size: CGFloat
    
    var body: some View {
        Image(icon)
            .resizable()
            .scaledToFit()
            .squareFrame(size)
    }
}
