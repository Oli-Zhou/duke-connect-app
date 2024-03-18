import Fluent
import Vapor

struct CreateUserGroup: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserGroup.schema)
            .id()
            .field("userId", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("groupId", .uuid, .required, .references(Group.schema, .id, onDelete: .cascade))
            .unique(on: "userId", "groupId")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserGroup.schema).delete()
    }
}
