//
//  singleImage.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct singleImage: View {
    var img: Image = Image(systemName: "person.circle.fill")
    var size: Double
    var body: some View {
        img
            .resizable()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    singleImage(size: 300)
}
