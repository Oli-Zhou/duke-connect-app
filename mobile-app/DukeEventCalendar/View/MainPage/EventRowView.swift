//
//  EventRowView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/2/23.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    var body: some View {
        VStack(alignment: .leading) {
            EventImage(imgURL: event.image).aspectRatio(2.5, contentMode: .fit)
                .shadow(radius: 15)
            Text(event.summary).fontWeight(.bold)
            Text(getFormattedDate(time: event.start_timestamp)).fontWeight(.semibold)
                .foregroundStyle(.gray)
            Text(event.sponsor).underline()
            HStack {
                Image(systemName: "mappin")
                Text(event.location.address)
                Spacer()
            }
        }

    }
}

#Preview {
    EventRowView(event: DataModel.sampleEvents![0])
}
