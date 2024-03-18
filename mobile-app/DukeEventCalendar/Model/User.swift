//
//  User.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/8/23.
//

import Combine
import Foundation

class User: ObservableObject {
    var userid: String = "" {
        didSet {
            if userid != "" {
                getFollowings()  // update following groups at the beginning
                Task {
                    await getInterested()
                }
                // TODO:
                //dummy methods:
                notificationManager.cancelNotifications()  //clear notifications for other user
                notificationManager.notifiedNotifications = []
                notificationManager.appendNotification(
                    n:
                        LocalNotification(
                            id: "1",
                            title: "Welcome, \(userid)!",
                            subtitle: "Enjoy our App!",
                            datetime: Date.now + 1,
                            repeats: false
                        )
                )
                notificationManager.appendNotification(
                    n:
                        LocalNotification(
                            id: "2",
                            title: "Tags in Filter Page",
                            subtitle:
                                "Hey \(userid)! Do you know you can `Long Press` on your selected tags to delete it?",
                            datetime: Date.now + 2,
                            repeats: false
                        )
                )
                notificationManager.appendNotification(
                    n:
                        LocalNotification(
                            id: "3",
                            title: "Our Team",
                            subtitle:
                                "Try connect with our developers: yw541@duke.edu, xz353@duke.edu and az161@duke.edu",
                            datetime: Date.now + 3,
                            repeats: false
                        )
                )
                Task {
                    await appendUserNotifications()
                }
            }
        }
    }
    @Published var interestedEvents: [String] = []
    @Published var followingGroups: [String] = []
    @Published var isLoggedin: Bool = false
    @Published var notificationManager = LocalNotificationManager()
    @Published var needLoading: Bool = false
    var picture: String?
    var interestedEventsEntity: [Event] = []

    var anyCancellable: AnyCancellable? = nil

    init() {
        anyCancellable = notificationManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        // Ensure changes in notificationManager will be observed
        // By default, Nested models does not work yet in SwiftUI
    }

    func getEvent(id: String) -> Event? {
        return self.interestedEventsEntity.first { $0.id == id }
    }

    func getInterestedIDAsync() async -> [String]? {
        await withCheckedContinuation { continuation in
            fetchEvents(forUser: self.userid) { res, error in
                if let res = res {
                    continuation.resume(returning: res)
                }
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    func getInterested() async {
        let interestedIDs = await getInterestedIDAsync()
        if let ids = interestedIDs {
            DispatchQueue.main.async {
                self.interestedEvents = ids
            }
            print("InterestedEvents updated, count:\(self.interestedEvents.count)")
        }
        for id in self.interestedEvents {
            getEventContent(id) { event, error in
                if let event = event {
                    if !self.interestedEventsEntity.contains(where: { $0.id == event.id }) {
                        self.interestedEventsEntity.append(event)
                    }
                }
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        print("##nil nil")
                    }
                }
            }
        }
    }

    func setAsInterested(event: Event) {
        addUserEvent(userName: self.userid, eventid: event.id) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    var tmp = self.interestedEvents
                    tmp.append(event.id)
                    self.interestedEvents = tmp
                }
                getEventContent(event.id) { event, error in
                    if let event = event {
                        self.appendUserNotification(event: event)
                    }
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func rmInterested(event: Event) {
        removeUserEvent(userName: self.userid, eventid: event.id) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.interestedEvents = self.interestedEvents.filter({ $0 != event.id })
                }
                getEventContent(event.id) { event, error in
                    if let event = event {
                        self.notificationManager.cancelNotification(
                            id: "\(self.userid) \(event.id)"
                        )
                    }
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }

    func getFollowings() {
        fetchGroups(forUser: self.userid) { result, error in
            if let res = result {
                DispatchQueue.main.async {
                    self.followingGroups = res
                    print("followingGroups updated, count:\(self.followingGroups.count)")
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func follow(groupName: String) {
        addUserToGroup(userName: self.userid, groupName: groupName) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.followingGroups.append(groupName)
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }

    func unfollow(groupName: String) {
        removeUserFromGroup(userName: self.userid, groupName: groupName) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.followingGroups = self.followingGroups.filter({ $0 != groupName })
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }

    //for all this user's interested events, if any of the event needs to be notified, notify it.
    func appendUserNotifications() async {
        let interestedIDs = await getInterestedIDAsync()
        guard let interestedIDs = interestedIDs else { return }
        for id in interestedIDs {
            getEventContent(id) { event, error in
                if let event = event {
                    self.appendUserNotification(event: event)
                }
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func appendUserNotification(event: Event) {
        if event.start_timestamp > Date.now + 30 * 60 {
            notificationManager.appendNotification(
                n: LocalNotification(
                    id: "\(userid) \(event.id)",
                    title: "30 Minutes Reminder",
                    subtitle:
                        "Your interested event \(event.summary) will start in 30 mins.",
                    datetime: event.start_timestamp - 30 * 60,
                    repeats: false
                )
            )
            print("user notification scheduled for \(event.summary)")
        }
    }
}

extension User {
    convenience init(userid: String, interestedEvents: [String], followingGroups: [String]) {
        self.init()
        self.userid = userid
        self.interestedEvents = interestedEvents
        self.followingGroups = followingGroups
    }

    convenience init(userid: String) {
        self.init()
        self.userid = userid
    }

    static let sampleUser = User(userid: "Aoli")
    static let sampleUser2 = User(
        userid: "userid2",
        interestedEvents: [sample_event.id],
        followingGroups: ["Duke Chapel"]
    )
}
