//
//  KeyboardWarmup.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct KeyboardWarmup: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            tf.becomeFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                tf.resignFirstResponder()
            }
        }
        return tf
    }
    func updateUIView(_ uiView: UITextField, context: Context) {}
}
