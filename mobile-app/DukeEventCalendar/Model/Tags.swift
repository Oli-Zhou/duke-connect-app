//
//  Tags.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/13/23.
//

import Foundation
import UIKit

enum TagType {
    case Category
    case Group
}

//source: https://medium.com/geekculture/tags-view-in-swiftui-e47dc6ce52e8
struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var size: CGFloat = 0
}

class TagRows: ObservableObject {
    var tags: [Tag] = []
    @Published var tagText = ""
    var chooseTag: (Tag) -> Bool = { tag in return true }

    var rows: [[Tag]] {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []

        var totalWidth: CGFloat = 0

        let screenWidth = UIScreen.screenWidth - 10
        let tagSpaceing: CGFloat =
            14 /*Leading Padding*/ + 14 /*Trailing Padding*/ + 6
            + 6 /*Leading & Trailing 6, 6 Spacing*/

        if !tags.isEmpty {

            for index in 0..<tags.count {
                self.tags[index].size = tags[index].name.getSize()
            }

            tags.forEach { tag in
                if chooseTag(tag) {
                    totalWidth += (tag.size + tagSpaceing)

                    if totalWidth > screenWidth {
                        totalWidth = (tag.size + tagSpaceing)
                        rows.append(currentRow)
                        currentRow.removeAll()
                        currentRow.append(tag)
                    }
                    else {
                        currentRow.append(tag)
                    }
                }
            }

            if !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow.removeAll()
            }

            return rows
        }
        else {
            return []
        }
    }

    func addTags(tagNames: [String]) {
        DispatchQueue.main.async {
            for name in tagNames {
                self.tags.append(Tag(name: name))
            }
            self.tagText = ""
        }
    }

    func addTag(tag: Tag) {
        if tags.filter({ $0.name == tag.name }).isEmpty {
            tags.append(tag)
            tagText = tag.name  // to enable change on published property
        }
    }

    func removeTag(by id: String) {
        tags = tags.filter { $0.id != id }
        tagText = id  // to enable change on published property
    }

    //for testing in preview
    static var categoriesTagRows: TagRows {
        let tagrows = TagRows()
        do {
            let categories: [String] = try load("Categories.json")
            tagrows.addTags(tagNames: categories)
        }
        catch {
            print(error.localizedDescription)
        }
        return tagrows
    }

    static var suggestedCategoriesTagRows: TagRows {
        let tagrows = TagRows()
        tagrows.addTag(tag: Tag(name: "Training"))
        tagrows.addTag(tag: Tag(name: "Free Food and Beverages"))
        tagrows.addTag(tag: Tag(name: "Party"))
        tagrows.addTag(tag: Tag(name: "Leadership"))
        tagrows.addTag(tag: Tag(name: "Social"))
        tagrows.addTag(tag: Tag(name: "Technology"))
        return tagrows
    }

    static var groupTagRows: TagRows {
        let tagrows = TagRows()
        do {
            let groups: [String] = try load("Groups.json")
            tagrows.addTags(tagNames: groups)
        }
        catch {
            print(error.localizedDescription)
        }
        return tagrows
    }
}

class TagRowsSearchable: TagRows {
    override init() {
        super.init()
        chooseTag = { tag in return tag.name.lowercased().contains(self.tagText.lowercased()) }
    }
}
