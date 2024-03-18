//
//  EventImage.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/18/23.
//

import SwiftUI

struct EventImage: View {
    var imgURL: URL?
    
    var body: some View {
        AsyncImage(url: imgURL) { image in
            image
                .resizable()
                .clipShape(
                    RoundedRectangle(
                        cornerSize: CGSize(
                            width: 10,
                            height: 10
                        )
                    )
                )
        } placeholder: {
            Image("event_default")
                .resizable()
                .clipShape(
                    RoundedRectangle(
                        cornerSize: CGSize(
                            width: 10,
                            height: 10
                        )
                    )
                )
        }
    }
}

#Preview {
    EventImage()
}
