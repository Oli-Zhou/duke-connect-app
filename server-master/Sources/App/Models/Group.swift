import Fluent
import Vapor

final class Group: Model, Content {
    static let schema = "groups"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Siblings(through: UserGroup.self, from: \.$group, to: \.$user)
    public var users: [User]

    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
