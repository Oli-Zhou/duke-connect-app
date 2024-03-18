//
//  groupDetail.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/6/23.
//

import SwiftUI

struct groupDetail: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    var group: String

    @State var isFollowing: Bool = false

    var body: some View {
        VStack {
            Text(group).font(.system(size: 20)).fontWeight(.heavy)
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .fill(isFollowing ? Color.gray : Color.blue)
                    .frame(width: 70, height: 30)
                Button(isFollowing ? "Following" : "Follow") {
                    if isFollowing {
                        user.unfollow(groupName: group)
                        isFollowing = false
                    }
                    else {
                        user.follow(groupName: group)
                        isFollowing = true
                    }
                }
                .font(.system(size: 11)).fontWeight(.bold)
                .tint(isFollowing ? Color.black : Color.white)
            }
            GroupEventList(group: group)
        }
        .onAppear {
            isFollowing = user.followingGroups.contains(group)
        }

    }
}

#Preview {
    groupDetail(group: "Duke Chapel")
        .environmentObject(DataModel())
        .environmentObject(User())
}
