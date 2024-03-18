import Fluent
import Vapor

struct CreateUserEvent: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserEvent.schema)
            .id()
            .field("userId", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("eventid", .string, .required)
            .unique(on: "userId", "eventid")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserEvent.schema).delete()
    }
}
