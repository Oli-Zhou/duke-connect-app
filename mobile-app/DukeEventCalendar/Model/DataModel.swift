//
//  DataModel.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/2/23.
//

import Foundation

class DataModel: ObservableObject {
    typealias EventFilter = (Event) -> Bool
    @Published var futureDays: Double
    @Published var dukeEvents: [Event]?
    @Published var excludeOngoing: Bool = false
    //@Published var comments: [Comment]?
    @Published var savedCateTags = TagRows()
    @Published var savedGroupTags = TagRows()
    @Published var isLoading = false
    var backupEvents: [Event]?

    var EventFilters: [EventFilter] {
        var filters: [EventFilter] = []
        filters.append(futureDaysFilter)
        if excludeOngoing {
            filters.append(notOnGoingFilter)
        }
        return filters
    }

    var filteredEvents: [Event] {
        guard var events = self.dukeEvents else { return [] }
        for filter in EventFilters {
            events = events.filter(filter)
        }
        print("Filtered Events' count: \(events.count)")
        return events
    }

    init() {
        self.futureDays = 1.0
        generateAndFetchEvents(
            groups: nil,
            categories: nil,
            futureDays: 30,
            dataModel: self,
            listType: .MainPageList
        )
        generateAndFetchEvents(
            groups: nil,
            categories: nil,
            futureDays: 30,
            dataModel: self,
            listType: .BackUpList
        )
        isLoading = true
    }

    func updateEvents() {
        let groups: [String] = savedGroupTags.tags.map { $0.name }
        let categories: [String] = savedCateTags.tags.map { $0.name }
        generateAndFetchEvents(
            groups: groups,
            categories: categories,
            futureDays: 30,
            dataModel: self,
            listType: .MainPageList
        )
        generateAndFetchEvents(
            groups: nil,
            categories: nil,
            futureDays: 30,
            dataModel: self,
            listType: .BackUpList
        )
        isLoading = true
    }

    func loadEvents() {
        //load data from events.json
        do {
            let tmpEvents: [String: [Event]] = try load("events.json")
            self.dukeEvents = tmpEvents["events"]
            self.backupEvents = tmpEvents["events"]
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func futureDaysFilter(event: Event) -> Bool {
        if event.start_timestamp
            <= Date(
                timeIntervalSinceNow: futureDays * 24 * 3600
            ) && event.end_timestamp > Date.now
        {
            return true
        }
        return false
    }

    //exclude the event if it already starts
    func notOnGoingFilter(event: Event) -> Bool {
        if event.start_timestamp < Date.now {
            return false
        }
        return true
    }

    static let sampleEvents: [Event]? = getSampleEvents()
    static func getSampleEvents() -> [Event]? {
        let url = Bundle.main.url(forResource: "sample_5", withExtension: "json")
        do {
            let data = try Data(contentsOf: url!)
            let decoder = JSONDecoder()
            let events = try decoder.decode([String: [Event]].self, from: data)
            let events_list = events["events"]
            return events_list
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }

    func getGroupEvents(groupName: String) -> [Event] {
        guard var events = self.backupEvents else { return [] }
        events = events.filter {
            $0.sponsor == groupName
                || (($0.co_sponsors != nil) && ($0.co_sponsors!.contains(groupName)))
        }
        return events
    }

//    func getEvent(eventid: String) -> Event? {
//        guard var events = self.backupEvents else { return nil }
//        events = events.filter { $0.id == eventid }
//        return events.first
//    }

    //An async version for fetch groups
    func fetchGroupsAsync(user: String) async -> [String]? {
        await withCheckedContinuation { continuation in
            fetchGroups(forUser: user) { groups, error in
                if let groups = groups {
                    continuation.resume(returning: groups)
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

    //For use in filter page.
    func loadUserFollowedGroupsForTags(user: String) async {
        let groups = await fetchGroupsAsync(user: user)
        if let groups = groups {
            self.savedGroupTags.tags = []
            self.savedGroupTags.addTags(tagNames: groups)
        }
    }

    //An async version for fetch categories
    func fetchCategoriesAsync(user: String) async -> [String]? {
        await withCheckedContinuation { continuation in
            fetchCategories(forUser: user) { cates, error in
                if let cates = cates {
                    continuation.resume(returning: cates)
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

    //For use in filter page.
    func loadUserFollowedCatesForTags(user: String) async {
        let cates = await fetchCategoriesAsync(user: user)
        if let cates = cates {
            self.savedCateTags.tags = []
            self.savedCateTags.addTags(tagNames: cates)
        }
    }

    func saveUserCurrentCates(user: String) async {
        let cates = await fetchCategoriesAsync(user: user)
        if let cates = cates {
            for c in cates {
                removeUserFromCategory(userName: user, categoryName: c) { res, error in
                    if res {
                        print("remove categories \(c) from server")
                    }
                }
            }
        }
        for c in self.savedCateTags.tags {
            addUserToCategory(userName: user, categoryName: c.name) { res, error in
                if res {
                    print("add categories \(c) to server")
                }
            }
        }
    }
}
