import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    ContentConfiguration.global.use(decoder: JSONDecoder.customDateDecoder, for: .json)

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .disable)
    ), as: .psql)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateGroup())
    app.migrations.add(CreateUserCategory())
    app.migrations.add(CreateUserGroup())
    app.migrations.add(CreateComment())
    app.migrations.add(CreateUserEvent())
    app.migrations.add(CreateEvent())

    app.views.use(.leaf)

    app.queues.schedule(EventFetchJob())
    .hourly()
    .at(35)

    //try await app.autoRevert().get()
    try await app.autoMigrate().get()

    // register routes
    try routes(app)
}

extension JSONDecoder {
    static let customDateDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}
