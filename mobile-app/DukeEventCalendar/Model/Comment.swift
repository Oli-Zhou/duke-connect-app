//
//  Comment.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/14/23.
//

import Foundation

struct Comment: Hashable, Codable {
    let id: UUID
    let upperComment: UUID?
    let eventid: String
    let userid: String
    let content: String
    let time: Date

    init(
        id: UUID = UUID(),
        eventid: String,
        userid: String,
        content: String,
        time: Date,
        upperComment: UUID? = nil
    ) {
        self.id = id
        self.upperComment = upperComment
        self.eventid = eventid
        self.userid = userid
        self.content = content
        self.time = time
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        let uppercomment_json = try? container.decodeIfPresent(UppercommentJson.self, forKey: .upperComment)
        let uppercomment_uuid = uppercomment_json?.id
        if let uuid_upper = uppercomment_uuid{
            self.upperComment = uuid_upper
        }else{
            self.upperComment = try? container.decodeIfPresent(UUID.self, forKey: .upperComment)
        }
        self.eventid = try container.decode(String.self, forKey: .eventid)
        self.userid = try container.decode(String.self, forKey: .userid)
        self.content = try container.decode(String.self, forKey: .content)
        let time_str = try container.decode(String.self, forKey: .time)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.time = dateFormatter.date(from: time_str)!
    }

    struct UppercommentJson: Decodable {
        let id: UUID?
    }
}
