//
//  ImagePagingControl.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/28/23.
//

import SwiftUI

struct ImagePagingControl: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    let test_data: [Event] = [
        DataModel.sampleEvents![0], DataModel.sampleEvents![1], DataModel.sampleEvents![2],
    ]  // for preview
    let data: [String]
    let activePageID: String?
    @State var needLoading: Bool = false
    
    var body: some View {
        ScrollViewReader { value in  //for auto scroll to my position
            ScrollView(.horizontal) {
                HStack {
                    ForEach(data, id: \.self) { event_id in
                        if let event = user.getEvent(id: event_id) {
                            EventCardImage(imgURL: event.image)
                                .scrollTransition(axis: .horizontal) { content, phase in
                                    content
                                        .scaleEffect(
                                            x: phase.isIdentity ? 1.2 : 0.6,
                                            y: phase.isIdentity ? 1.2 : 0.6
                                        )
                                        .blur(radius: phase.isIdentity ? 0 : 0.8)
                                }
                        }
                    }
                }
                .padding()
            }
            .onChange(of: activePageID) {
                if let id = activePageID {
                    withAnimation {
                        value.scrollTo(id)
                    }
                }
            }
            .disabled(true)
        }
        .safeAreaPadding(.horizontal, 150)
    }
}

#Preview {
    ImagePagingControl(
        data: [],
        activePageID: ""
    )
    .environmentObject(DataModel())
    .environmentObject(User())
}
