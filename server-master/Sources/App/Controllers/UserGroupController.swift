import Vapor
import Fluent

struct UserGroupController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userGroups = routes.grouped("user-groups")
        userGroups.get("groups", use: getGroupsForUser)
        userGroups.post("add", use: addUserToGroup)
        userGroups.delete("remove", use: removeUserFromGroup)
    }

    
    func getGroupsForUser(req: Request) async throws -> [String] {
        guard let userName = req.query[String.self, at: "username"] else {
            throw Abort(.badRequest)
        }
        
        guard let user = try await User.query(on: req.db)
                                .filter(\.$name == userName)
                                .first()
                                //.unwrap(or: Abort(.notFound)) 
                                else {
            throw Abort(.notFound)
        }

        let groups = try await user.$groups.query(on: req.db).all()
        return groups.map(\.name)
    }


    func addUserToGroup(req: Request) async throws -> HTTPStatus {
        let (user, group) = try await fetchUserAndGroup(req: req)
        let userGroup = UserGroup(userId: user.id!, groupId: group.id!)
        try await userGroup.save(on: req.db)
        return .ok
    }

    func removeUserFromGroup(req: Request) async throws -> HTTPStatus {
        let (user, group) = try await fetchUserAndGroup(req: req)
        try await UserGroup.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$group.$id == group.id!)
            .delete()
        return .ok
    }

    private func fetchUserAndGroup(req: Request) async throws -> (User, Group) {
        guard let userName = req.query[String.self, at: "username"],
            let groupName = req.query[String.self, at: "groupname"] else {
            throw Abort(.badRequest)
        }
        print("userName:\(userName), groupName:\(groupName)")
        guard let user = try await User.query(on: req.db)
                                    .filter(\.$name == userName)
                                    .first()
                                    //.unwrap(or: Abort(.notFound)) 
                                    else {
            throw Abort(.notFound, reason: "User not found")
        }

        guard let group = try await Group.query(on: req.db)
                                    .filter(\.$name == groupName)
                                    .first()
                                    //.unwrap(or: Abort(.notFound)) 
                                    else {
            throw Abort(.notFound, reason: "Group not found")
        }

        return (user, group)
    }

}
