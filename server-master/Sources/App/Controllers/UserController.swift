import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.post("updateAvatar", use: updateAvatar)
        users.group(":userID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [User] {
        return try await User.query(on: req.db).all()
    }

    func create(req: Request) async throws -> UserDTO {
        let userDTO = try req.content.decode(UserDTO.self)
        if let existingUser = try await User.query(on: req.db)
            .filter(\.$name == userDTO.name)
            .first() {
            return UserDTO(name: existingUser.name, avatar: existingUser.avatar)
        } else {
            let user = User(name: userDTO.name, avatar: userDTO.avatar)
            try await user.save(on: req.db)
            return userDTO
        }
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }

    func updateAvatar(req: Request)  async throws -> HTTPStatus{
        let userDTO = try req.content.decode(UserDTO.self)
        if let existingUser = try await User.query(on: req.db)
            .filter(\.$name == userDTO.name)
            .first() {
            existingUser.avatar = userDTO.avatar
            try await existingUser.save(on: req.db)
            return .ok
        } else {
            return .notFound
        }
    }
}
