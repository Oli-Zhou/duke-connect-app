//
//  FilterPageView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/6/23.
//

import SwiftUI

struct FilterPageView: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    @StateObject var categoryTagRows = TagRowsSearchable()
    @StateObject var groupTagRows = TagRowsSearchable()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Filter")
                        .font(.title)
                    Text("Show events within").fontWeight(.bold)

                    HStack {
                        Slider(value: $datamodel.futureDays, in: 1.0...30.0, step: 1.0)
                            .frame(width: 250)
                        Spacer()
                        Text("\(Int(datamodel.futureDays)) days").padding()
                    }
                    Divider()
                    Toggle(isOn: $datamodel.excludeOngoing) {
                        Text("Show events that haven't started")
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .toggleStyle(iOSCheckboxToggleStyle())
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    Divider()
                    categoriesEdit
                    Divider()
                    groupEdit
                }
                .padding()
            }
        }
        .onAppear {
            do {
                let categories: [String] = try load("Categories.json")
                categoryTagRows.addTags(tagNames: categories)
                let groups: [String] = try load("Groups.json")
                groupTagRows.addTags(tagNames: groups)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        .onDisappear {
            datamodel.updateEvents()
        }
    }

    var categoriesEdit: some View {
        Group {
            VStack(alignment: .leading) {
                Text("Add Categories")
                    .font(.title2)
                    .padding(.bottom, -2)
                Button {
                    Task {
                        await datamodel.loadUserFollowedCatesForTags(user: user.userid)
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.primary)
                        .frame(width: 220, height: 22)
                        .overlay {
                            Text("Load My Categories")
                                .foregroundStyle(.white)
                        }
                }
                Button {
                    Task {
                        await datamodel.saveUserCurrentCates(user: user.userid)
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.primary)
                        .frame(width: 220, height: 22)
                        .overlay {
                            Text("Save Current Categories")
                                .foregroundStyle(.white)
                        }
                }
            }
            SearchBarView(
                searchFieldDefault: "Search Categories",
                searchText: $categoryTagRows.tagText
            )
            TagRowsDeletableView(tagType: .Category, tagRows: datamodel.savedCateTags)
            Divider()
            Text("Category Suggestions")
                .foregroundStyle(.secondary)
            if categoryTagRows.tagText == "" {
                TagRowsAddableView(
                    tagType: .Category,
                    tagRows: TagRows.suggestedCategoriesTagRows,
                    tagRowsSaved: datamodel.savedCateTags
                )
            }
            else {
                TagRowsAddableView(
                    tagType: .Category,
                    tagRows: categoryTagRows,
                    tagRowsSaved: datamodel.savedCateTags
                )
            }
        }
    }

    var groupEdit: some View {
        Group {
            VStack(alignment: .leading) {
                Text("Add Groups")
                    .font(.title2)
                    .padding(.bottom, -2)
                Button {
                    Task {
                        await datamodel.loadUserFollowedGroupsForTags(user: user.userid)
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.primary)
                        .frame(width: 220, height: 22)
                        .overlay {
                            Text("Load My Followed Groups")
                                .foregroundStyle(.white)
                        }
                }
            }
            SearchBarView(
                searchFieldDefault: "Search Groups",
                searchText: $groupTagRows.tagText
            )
            TagRowsDeletableView(tagType: .Group, tagRows: datamodel.savedGroupTags)
            Divider()
            TagRowsAddableView(
                tagType: .Group,
                tagRows: groupTagRows,
                tagRowsSaved: datamodel.savedGroupTags
            )
        }
    }
}

#Preview {
    FilterPageView()
        .environmentObject(DataModel())
        .environmentObject(User())
}
