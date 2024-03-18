import Fluent
import Vapor

struct CreateUserCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserCategory.schema)
            .id()
            .field("userId", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("categoryId", .uuid, .required, .references(Category.schema, .id, onDelete: .cascade))
            .unique(on: "userId", "categoryId")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserCategory.schema).delete()
    }
}