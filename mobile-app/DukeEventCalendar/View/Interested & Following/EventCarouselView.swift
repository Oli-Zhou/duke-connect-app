//
//  EventCarouselView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/28/23.
//

import SwiftUI

struct EventCarouselView: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    let testCards = [
        DataModel.sampleEvents![0], DataModel.sampleEvents![1], DataModel.sampleEvents![2],
    ]  // data for preview
    let data: [String]
    @State private var activePageID: String?  //Event's id is string type
    @State var pickerType: EventPicker
    @State var needLoading: Bool = false

    var filteredData: [String] {
        return user.interestedEvents.filter { id in
            if let event = user.getEvent(id: id) {
                if pickerType == .past {
                    return event.start_timestamp < Date.now
                }
                else {
                    return event.start_timestamp > Date.now
                }
            }
            else {
                return false
            }
        }
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                if !needLoading {
                    LazyHStack {
                        ForEach(filteredData, id: \.self) { event_id in
                            if let event = user.getEvent(id: event_id) {
                                NavigationLink {
                                    EventDetail(event: event)
                                } label: {
                                    EventCard(event: event)
                                        .containerRelativeFrame(.horizontal)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .scaleEffect(
                                                    x: phase.isIdentity ? 1.2 : 0.8,
                                                    y: phase.isIdentity ? 1.2 : 0.8
                                                )
                                                .rotation3DEffect(
                                                    .degrees(phase.value * 30.0),
                                                    axis: (x: 0, y: 1, z: 0)
                                                )
                                        }
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                }  // allow the ScrollView to understand where to find the identifiers for the binding
            }
            .scrollIndicators(.hidden)
            .scrollPosition(id: $activePageID)
            Spacer()
            ImagePagingControl(data: filteredData, activePageID: activePageID)
                .offset(y: -50)
        }
        .onAppear {
            if filteredData.count == 0 {
                needLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    needLoading = false
                }
            }
        }
    }
}

#Preview {
    EventCarouselView(data: [], pickerType: .future)
        .environmentObject(DataModel())
        .environmentObject(User())
}
