import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
    try app.register(collection: UserController())
    try app.register(collection: UserGroupController())
    try app.register(collection: UserCategoryController())
    try app.register(collection: CommentController())
    try app.register(collection: UserEventController())
}
