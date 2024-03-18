//
//  ProfilePage.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/21/23.
//

import SwiftUI

struct ProfilePage: View {
    @EnvironmentObject var user: User

    var notificationCount: Int {
        user.notificationManager.notifiedNotifications.count
    }

    var body: some View {
        VStack {
            //            PickablePhotoView()
            //                .padding()
            UserAvatar(name: user.userid, size: 180)
            Text(user.userid).font(.system(size: 30)).fontWeight(.heavy)
                .padding(.horizontal, 20.0)
            HStack {
                Text("Notifications (\(notificationCount))")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                Button {
                    withAnimation {
                        if notificationCount != 0 {
                            user.notificationManager.notifiedNotifications.removeFirst()
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .overlay {
                            Text("Read and Clear")
                                .foregroundStyle(.black)
                        }
                        .frame(width: 140, height: 27)
                        .foregroundStyle(.ultraThinMaterial)
                }
            }
            ScrollView {
                VStack {
                    ForEach(user.notificationManager.notifiedNotifications, id: \.id) {
                        notification in
                        NotificationRowView(notification: notification)
                            .padding(.top)
                            .transition(.slide)
                            .scrollTransition(axis: .vertical) { content, phase in
                                content
                                    .scaleEffect(
                                        x: phase.isIdentity ? 1 : 0.6,
                                        y: phase.isIdentity ? 1 : 0.6
                                    )
                                    .rotation3DEffect(
                                        .degrees(phase.value * 90.0),
                                        axis: (x: 1, y: 0, z: 0)
                                    )
                            }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            Button {
                user.userid = ""
                user.isLoggedin = false
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .overlay {
                            Text("Log Out")
                                .foregroundStyle(.white)
                        }
                }
            }
            .frame(width: 90, height: 35)
            .padding()
        }
    }
}

#Preview {
    ProfilePage().environmentObject(User())
}
