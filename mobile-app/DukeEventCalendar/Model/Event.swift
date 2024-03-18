//
//  Event.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/29/23.
//

import Foundation


class Event: Decodable, ObservableObject {
    //json data specific
    let id: String
    let start_timestamp: Date
    let end_timestamp: Date
    let summary: String
    let description: String
    let status: EventStatus
    let sponsor: String
    let co_sponsors: [String]?
    let location: Location
    let contact: Contact
    let categories: [String]?
    let link: URL
    let event_url: URL?
    let submitted_by: [String]
    let presenter: String?
    let image: URL?
    let image_alt_text: String?

    private enum CodingKeys: CodingKey {
        case id
        case start_timestamp
        case end_timestamp
        case summary
        case description
        case status
        case sponsor
        case co_sponsors
        case location
        case contact
        case categories
        case link
        case event_url
        case submitted_by
        case presenter
        case image
        case image_alt_text
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        let starttime_str = try container.decode(String.self, forKey: .start_timestamp)
        let endtime_str = try container.decode(String.self, forKey: .end_timestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.start_timestamp = dateFormatter.date(from: starttime_str)!  //MARK: forced unwrapping here, we suppose the json date data is good.
        self.end_timestamp = dateFormatter.date(from: endtime_str)!  //MARK: forced unwrapping here, we suppose the json date data is good.

        self.summary = try container.decode(String.self, forKey: .summary)
        self.description = try container.decode(String.self, forKey: .description)
        self.status = try container.decode(EventStatus.self, forKey: .status)
        self.sponsor = try container.decode(String.self, forKey: .sponsor)
        self.co_sponsors = try container.decodeIfPresent([String].self, forKey: .co_sponsors)
        self.location = try container.decode(Location.self, forKey: .location)
        self.contact = try container.decode(Contact.self, forKey: .contact)
        self.categories = try container.decodeIfPresent([String].self, forKey: .categories)
        self.link = try container.decode(URL.self, forKey: .link)
        self.event_url = try container.decodeIfPresent(URL.self, forKey: .event_url)
        self.submitted_by = try container.decode([String].self, forKey: .submitted_by)
        self.presenter = try container.decodeIfPresent(String.self, forKey: .presenter)
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.image_alt_text = try container.decodeIfPresent(String.self, forKey: .image_alt_text)
    }

    //comments
    @Published var comments: [Comment] = []

    var mainComments: [Comment] {
        self.comments.filter { $0.upperComment == nil }
    }

    func getSubComments(cmtid: UUID) -> [Comment] {
        return self.comments.filter { $0.upperComment == cmtid }
    }

    func fetchCommentsFromServer() {
        fetchComments(forEventID: self.id) { comments, error in
            if let comments = comments {
                DispatchQueue.main.async {
                    self.comments = comments
                    print("\(self.comments.count) comments")
                }
            }
            else {
                if let error = error {
                    print(error)
                }else{
                    print("fetch comments: nil nil")
                }
            }
        }
    }

    func addComment(comment: Comment) async -> Bool {
        await withCheckedContinuation { continuation in
            var res = false
            createComment(comment) { createdComment, error in
                if let createdComment = createdComment {
                    DispatchQueue.main.async {
                        self.comments.append(createdComment)
                    }
                    res = true
                }
                else {
                    if let error = error {
                        print(error)
                    }else{
                        print("##nil nil##")
                    }
                }
                continuation.resume(returning: res)
            }
        }
    }

    func deleteCommentFromServer(cmtid: UUID) {
        deleteComment(withID: cmtid) { res, error in
            if res == true {
                DispatchQueue.main.async {
                    self.comments = self.comments.filter {
                        ($0.id != cmtid) && ($0.upperComment != cmtid)
                    }
                    print("comment deleted")
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    print("delete ##nil nil##")
                }
            }

        }
    }
}

extension Event {
    //The date components for importing into apple calendar
    var calendarStartDate: DateComponents {
        return Calendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute],
            from: start_timestamp
        )
    }

    var calendarEndDate: DateComponents {
        return Calendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute],
            from: end_timestamp
        )
    }
}

enum EventStatus: String, Decodable {
    case confirmed = "CONFIRMED"
    case cancelled = "CANCELLED"
    case tentative = "TENTATIVE"
}

struct Location: Decodable {
    let address: String
    let link: URL?

    enum CodingKeys: CodingKey {
        case address
        case link
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(String.self, forKey: .address)
        self.link =
            (try? container.decodeIfPresent(URL.self, forKey: .link)) ?? URL(string: "Invalid Link")
    }
}

struct Contact: Decodable {
    let name: String
    let phone: String?
    let email: String?
}
