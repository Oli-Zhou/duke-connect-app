//
//  InterestedEvents.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import SwiftUI

enum EventPicker: String, CaseIterable {
    case future = "Future"
    case past = "Past"
}

struct InterestedEvents: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    @State private var pickerType = EventPicker.future
    //@State var eventPicked: Event?

    var futureEvents: [String] {
        return user.interestedEvents.filter { id in
            if let event = user.getEvent(id: id) {
                return event.start_timestamp > Date.now
            }
            else {
                return false
            }
        }
    }

    var pastEvents: [String] {
        return user.interestedEvents.filter { id in
            if let event = user.getEvent(id: id) {
                return event.start_timestamp < Date.now
            }
            else {
                return false
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $pickerType) {
                    ForEach(EventPicker.allCases, id: \.rawValue) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                if pickerType == .future {
                    EventCarouselView(data: futureEvents, pickerType: .future)
                }
                else {
                    EventCarouselView(data: pastEvents, pickerType: .past)
                }
            }
            .navigationTitle("Interested Events")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                await user.getInterested()
            }
        }
    }
}

#Preview {
    InterestedEvents()
        .environmentObject(DataModel())
        .environmentObject(User())
}
