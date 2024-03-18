import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @OptionalField(key: "avatar")
    var avatar: String?

    @Siblings(through: UserGroup.self, from: \.$user, to: \.$group)
    public var groups: [Group]

    @Siblings(through: UserCategory.self, from: \.$user, to: \.$category)
    public var categories: [Category]

    init() { }

    init(id: UUID? = nil, name: String, avatar: String? = nil) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
}

struct UserDTO: Content {
    var name: String
    var avatar: String?
}
