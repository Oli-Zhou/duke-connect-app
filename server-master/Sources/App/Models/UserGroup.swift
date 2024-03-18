import Fluent
import Vapor
final class UserGroup: Model {
    static let schema = "user_group"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "userId")
    var user: User

    @Parent(key: "groupId")
    var group: Group

    init() { }

    init(id: UUID? = nil, userId: UUID, groupId: UUID) {
        self.id = id
        self.$user.id = userId
        self.$group.id = groupId
    }
}