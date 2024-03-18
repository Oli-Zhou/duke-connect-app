//
//  Time&Loc&Desc.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/18/23.
//

import SwiftUI

struct Time_Loc_Desc: View {
    @State var showDesc = false
    var event: Event

    var body: some View {
        VStack(alignment: .leading){
            if dateToStringDate(time: event.start_timestamp)
                == dateToStringDate(time: event.end_timestamp)
            {
                Label(dateToStringDate(time: event.start_timestamp), systemImage: "calendar")
                Label("\(dateToStringTime(time: event.start_timestamp)) - \(dateToStringTime(time: event.end_timestamp))", systemImage: "clock")
            }
            else {
                Text(
                    "\(dateToString(time:event.start_timestamp)) to \(dateToString(time:event.end_timestamp))"
                )
            }
            HStack {
                Image(systemName: "mappin")
                    .foregroundColor(.red)
                Text(event.location.address)

                if let url = event.location.link {
                    Button(
                        "",
                        systemImage: "map",
                        action: { UIApplication.shared.open(url) }
                    )// 　link to map
                }
            }
            
            Text("\nEvent Description").font(.system(size: 25)).fontWeight(.bold)
            if showDesc {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color(CGColor(gray: 0.3, alpha: 0.2)))
                    Text(event.description).padding(5)
                }
                Button("Hide Description") { showDesc.toggle() }
            }
            else {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color(CGColor(gray: 0.3, alpha: 0.2)))
                    Text(event.description).padding(5)
                }.frame(height: 100)
                Button("Read More") { showDesc.toggle() }
            }
        }.font(.system(size: 18))
    }
}

#Preview {
//    Time_Loc_Desc(event: sample_event)
    Time_Loc_Desc(event: sampleEvents![6])
}
