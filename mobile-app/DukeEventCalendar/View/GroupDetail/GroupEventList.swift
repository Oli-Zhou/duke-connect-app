//
//  GroupEventList.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import SwiftUI

struct GroupEventList: View {
    @EnvironmentObject var datamodel:DataModel
    var group: String
    var body: some View {
            List {
                Text("Future Events (\(datamodel.getGroupEvents(groupName: group).count))").padding(.leading, 10.0).font(.system(size: 18)).fontWeight(.bold)
                ForEach(datamodel.getGroupEvents(groupName: group) , id: \.id) { event in
                    NavigationLink {
                        EventDetail(event: event)
                    } label: {
                        EventRowView(event: event)
                    }
                }
            }
    }
}

#Preview {
    GroupEventList(group: "Duke Chapel").environmentObject(DataModel())
}
