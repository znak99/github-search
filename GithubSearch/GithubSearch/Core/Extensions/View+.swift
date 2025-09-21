//
//  View+.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

// View 共通拡張
extension View {
    func squareFrame(_ size: CGFloat, range: CGFloat = 8) -> some View {
        self.modifier(FrameModifier(size: size, range: range))
    }

    func dismissKeyboardOnTap() -> some View {
        self.modifier(KeyboardDismissOverlay())
    }
}
