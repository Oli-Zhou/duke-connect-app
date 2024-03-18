//
//  FollowingGroups.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import SwiftUI

struct FollowingGroups: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User

    var body: some View {
        NavigationView {
            List {
                ForEach(user.followingGroups, id: \.self) { group in
                    NavigationLink {
                        groupDetail(group: group)
                    } label: {
                        Text(group)
                    }
                }
            }
            .navigationTitle("Following")
            .onAppear{
                user.getFollowings()
            }
        }
    }
}

#Preview {
    FollowingGroups()
        .environmentObject(DataModel())
        .environmentObject(User())
}
