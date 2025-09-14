//
//  AppIcon.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

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

#Preview {
    SquareAppIcon(icon: "github", size: 40)
}
