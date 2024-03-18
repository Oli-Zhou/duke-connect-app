//
//  EventCardImage.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/27/23.
//

import SwiftUI

struct EventCardImage: View {
    var imgURL: URL?

    var body: some View {
        AsyncImage(url: imgURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
        } placeholder: {
            Image("event_default")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
        }
    }
}

#Preview {
    EventCardImage()
}
