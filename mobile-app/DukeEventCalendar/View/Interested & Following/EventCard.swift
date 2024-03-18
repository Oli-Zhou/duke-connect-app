//
//  EventCard.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/26/23.
//

import SwiftUI

struct EventCard: View {
    let event: Event
    var theme: Theme {
        return Theme[Int.random(in: 0...15)]
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.mainColor.opacity(0.6), theme.mainColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(.ultraThinMaterial, lineWidth: 3)
                }
                .shadow(radius: 10)

            VStack(
                alignment: .leading
            ) {
                EventImage(imgURL: event.image)
                    .scaledToFit()
                    .frame(width: 260, height: 160)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top)
                Text(event.summary).font(.system(size: 18))
                    .fontWeight(.black)
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    Label(dateToStringDate(time: event.start_timestamp), systemImage: "calendar")
                    Label(
                        "\(dateToStringTime(time: event.start_timestamp)) - \(dateToStringTime(time: event.end_timestamp))",
                        systemImage: "clock"
                    )
                    if event.start_timestamp > Date.now {
                        Text("Start In \(event.start_timestamp, style: .relative)")
                    }
                    else {
                        Text("Started \(event.start_timestamp, style: .relative) ago")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
                .padding(.horizontal)
                .padding(.bottom)
            }
            .foregroundStyle(Color(theme.accentColor))
        }
        .frame(width: 260,height: 100)
    }
}

#Preview {
    EventCard(event: sampleEvents![3])
}
