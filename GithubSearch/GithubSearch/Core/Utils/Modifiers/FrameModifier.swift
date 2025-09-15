//
//  FrameModifier.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// View に正方形の frame サイズを付与する Modifier
struct FrameModifier: ViewModifier {
    let size: CGFloat
    let range: CGFloat
    
    func body(content: Content) -> some View {
        content.frame(
            minWidth: size <= 12 ? size : size - range, // 12以下に小さくはしない
            idealWidth: size,
            maxWidth: size + range,
            minHeight: size <= 12 ? size : size - range, // 12以下に小さくはしない
            idealHeight: size,
            maxHeight: size + range,
            alignment: .center
        )
    }
}
