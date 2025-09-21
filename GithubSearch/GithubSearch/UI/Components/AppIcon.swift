//
//  AppIcon.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct AppIconFrame: View {
    
    let icon: String
    let size: CGFloat
    
    var body: some View {
        Image(icon)
            .resizable()
            .scaledToFit()
            .squareFrame(size)
    }
}

#Preview {
    AppIconFrame(icon: "github", size: 40)
}
