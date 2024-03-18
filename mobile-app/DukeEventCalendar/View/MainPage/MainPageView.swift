//
//  MainPageView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/6/23.
//

import SwiftUI

struct MainPageView: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    var body: some View {
        NavigationView {
            if datamodel.isLoading {
                ProgressView()
                    .navigationTitle("Events")
            }
            else {
                List {
                    ForEach(datamodel.filteredEvents, id: \.id) { event in
                        NavigationLink {
                            EventDetail(event: event)
                        } label: {
                            EventRowView(event: event)
                        }
                    }
                }
                .listStyle(.inset)
                .toolbarTitleDisplayMode(.automatic)
                .navigationTitle("Events (\(datamodel.filteredEvents.count))")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            FilterPageView()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                }
                .refreshable {
                    datamodel.updateEvents()
                }
            }
        }
    }
}

#Preview {
    MainPageView()
        .environmentObject(DataModel())
        .environmentObject(User())
}
