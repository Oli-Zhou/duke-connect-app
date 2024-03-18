import Fluent
import Vapor
final class UserEvent: Model {
    static let schema = "user_event"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "userId")
    var user: User

    @Field(key: "eventid")
    var eventid: String

    init() { }

    init(id: UUID? = nil, userId: UUID, eventid: String) {
        self.id = id
        self.$user.id = userId
        self.eventid = eventid
    }
}