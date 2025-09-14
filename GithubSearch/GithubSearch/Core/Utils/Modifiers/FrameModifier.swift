//
//  FrameModifier.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct FrameModifier: ViewModifier {
    let size: CGFloat
    let range: CGFloat
    
    func body(content: Content) -> some View {
        content.frame(
            minWidth: size - range, idealWidth: size, maxWidth: size + range,
            minHeight: size - range, idealHeight: size, maxHeight: size + range,
            alignment: .center
        )
    }
}
