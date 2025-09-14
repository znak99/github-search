//
//  KeyboardDismissOverlay.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI
import UIKit

struct KeyboardDismissOverlay: ViewModifier {
    @State private var isKeyboardVisible = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isKeyboardVisible {
                Color.clear
                    .contentShape(Rectangle())
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in UIApplication.shared.hideKeyboard() }
                    )
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = true
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = false
            }
        }
    }
}
