import Fluent
import Vapor

final class Comment: Model, Content {
    static let schema = "comments"

    @ID(key: .id)
    var id: UUID?

    @OptionalParent(key: "upperComment")
    var upperComment: Comment?

    @Field(key: "eventid")
    var eventid: String

    @Field(key: "userid")
    var userid: String

    @Field(key: "content")
    var content: String

    @Field(key: "time")
    var time: Date

    init() {}

    init(_ comment: CommentDTO){
        self.id = comment.id
        self.$upperComment.id = comment.upperComment
        self.eventid = comment.eventid
        self.userid = comment.userid
        self.content = comment.content
        self.time = comment.time
    }

    init(id: UUID? = nil, upperComment: UUID? = nil, eventid: String, userid: String, content: String, time: Date) {
        self.id = id
        self.$upperComment.id = upperComment
        self.eventid = eventid
        self.userid = userid
        self.content = content
        self.time = time
    }
}

struct CommentDTO: Content {
    var id: UUID?
    var upperComment: UUID?
    var eventid: String
    var userid: String
    var content: String
    var time: Date
}
