import Fluent
import Foundation

struct CreateCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("categories")
            .id()
            .field("name", .string, .required)
            .unique(on: "name")
            .create()

        try await insertCategoriesFromFile(to: database)

    }

    func revert(on database: Database) async throws {
        try await database.schema("categories").delete()
    }

    private func insertCategoriesFromFile(to database: Database) async throws {
        let fileData = try await readFileData(path: "Resources/Files/Categories.json")
        
        let categoryNames = try JSONDecoder().decode([String].self, from: fileData)

        for name in categoryNames {
            let category = Category(name: name)
            try await category.save(on: database)
        }
    }

    private func readFileData(path: String) async throws -> Data {
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}
