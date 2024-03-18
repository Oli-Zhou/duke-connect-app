//
//  UserAvatar.swift
//  DukeEventCalendar
//
//  Created by xz353 on 12/7/23.
//

import SwiftUI

struct UserAvatar: View {
    let name: String
    var size: Double
    var body: some View {
        AsyncImage(url: URL(string: "https://ui-avatars.com/api/?name=\(name)&background=random&size=512")) {
            image in
            image
                .resizable()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)

        } placeholder: {
            Image("person.circle.fill")
                .resizable()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
        }
    }
}

#Preview {
    UserAvatar(name: "az161", size: 200)
}
