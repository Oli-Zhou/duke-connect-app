//
//  DukeEventCalendarApp.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/28/23.
//

import SwiftUI

@main
struct DukeEventCalendarApp: App {
    var loader1 = WebPageLoader()
    var loader2 = WebPageLoader()
    @StateObject var datamodel: DataModel = DataModel()
    @StateObject var user: User = User()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(datamodel)
                .environmentObject(user)
                .onAppear {
                    let urlString = "https://urlbuilder.calendar.duke.edu/"
                    if let url = URL(string: urlString) {
                        loader1.loadOptions(from: url, selectElementID: "categorieselect") {
                            (options, error) in
                            if let options = options {
                                // Output to console
                                saveOptions(options: options, withFileName: "Categories.json")
                                print(options.count)
                            }
                            else if let error = error {
                                print("Error: \(error)")
                            }
                        }
                        loader2.loadOptions(from: url, selectElementID: "groupselect") {
                            (options, error) in
                            if let options = options {
                                // Output to console
                                saveOptions(options: options, withFileName: "Groups.json")
                                print(options.count)
                            }
                            else if let error = error {
                                print("Error: \(error)")
                            }
                        }
                    }
                }
        }
    }
}
