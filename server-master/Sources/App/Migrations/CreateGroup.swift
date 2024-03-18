import Fluent
import Foundation

struct CreateGroup: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("groups")
            .id()
            .field("name", .string, .required)
            .unique(on: "name")
            .create()

        try await insertGroupsFromFile(to: database)

    }

    func revert(on database: Database) async throws {
        try await database.schema("groups").delete()
    }

    private func insertGroupsFromFile(to database: Database) async throws {
        let fileData = try await readFileData(path: "Resources/Files/Groups.json")
        
        let groupNames = try JSONDecoder().decode([String].self, from: fileData)

        for name in groupNames {
            let group = Group(name: name)
            try await group.save(on: database)
        }
    }

    private func readFileData(path: String) async throws -> Data {
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}
