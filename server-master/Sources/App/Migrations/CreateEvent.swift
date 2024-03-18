import Fluent
import Vapor

struct CreateEvent: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Event.schema)
            .field("id", .string, .identifier(auto: false))
            .field("start_timestamp", .datetime, .required)
            .field("end_timestamp", .datetime, .required)
            .field("summary", .string, .required)
            .field("description", .string, .required)
            .field("status", .string, .required)
            .field("sponsor", .string, .required)
            .field("co_sponsors", .array(of: .string))
            .field("location_address", .string, .required)
            .field("location_link", .string)
            .field("contact_name", .string, .required)
            .field("contact_phone", .string)
            .field("contact_email", .string)
            .field("categories", .array(of: .string))
            .field("submitted_by", .array(of: .string), .required)
            .field("presenter", .string)
            .field("image_alt_text", .string)
            .field("link", .string, .required)
            .field("event_url", .string)
            .field("image", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("events").delete()
    }
}
