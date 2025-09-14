//
//  AppIcon.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct AppIcon: View {
    
    let icon: String
    let size: CGFloat
    
    var body: some View {
        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(
                minWidth: size - 8, idealWidth: size, maxWidth: size + 8,
                minHeight: size - 8, idealHeight: size, maxHeight: size + 8)
    }
}

#Preview {
    AppIcon(icon: "github", size: 40)
}
