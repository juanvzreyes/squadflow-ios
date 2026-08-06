//
//  AvatarCircleView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import SwiftUI

struct AvatarCircleView: View {
    let avatarUrl: String?
    var selectedImage: Image?
    var size: CGFloat = 56

    var body: some View {
        Group {
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFill()
            } else if let urlString = avatarUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
