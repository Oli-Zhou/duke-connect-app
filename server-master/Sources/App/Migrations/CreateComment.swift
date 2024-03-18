import Fluent
import Vapor

struct CreateComment: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("comments")
            .id()
            .field("upperComment", .uuid, .references(Comment.schema, .id, onDelete: .cascade))
            .field("eventid", .string, .required)
            .field("userid", .string, .required)
            .field("content", .string, .required)
            .field("time", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("comments").delete()
    }
}
