import Vapor
import Fluent

struct UserCategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userCategories = routes.grouped("user-categories")
        userCategories.get("categories", use: getCategoriesForUser)
        userCategories.post("add", use: addUserToCategory)
        userCategories.delete("remove", use: removeUserFromCategory)
    }

    
    func getCategoriesForUser(req: Request) async throws -> [String] {
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

        let categories = try await user.$categories.query(on: req.db).all()
        return categories.map(\.name)
    }


    func addUserToCategory(req: Request) async throws -> HTTPStatus {
        let (user, category) = try await fetchUserAndCategory(req: req)
        let userCategory = UserCategory(userId: user.id!, categoryId: category.id!)
        try await userCategory.save(on: req.db)
        return .ok
    }

    func removeUserFromCategory(req: Request) async throws -> HTTPStatus {
        let (user, category) = try await fetchUserAndCategory(req: req)
        try await UserCategory.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$category.$id == category.id!)
            .delete()
        return .ok
    }

    private func fetchUserAndCategory(req: Request) async throws -> (User, Category) {
        guard let userName = req.query[String.self, at: "username"],
            let categoryName = req.query[String.self, at: "categoryname"] else {
            throw Abort(.badRequest)
        }
        print("userName:\(userName), categoryName:\(categoryName)")
        guard let user = try await User.query(on: req.db)
                                    .filter(\.$name == userName)
                                    .first()
                                    //.unwrap(or: Abort(.notFound)) 
                                    else {
            throw Abort(.notFound, reason: "User not found")
        }

        guard let category = try await Category.query(on: req.db)
                                    .filter(\.$name == categoryName)
                                    .first()
                                    //.unwrap(or: Abort(.notFound)) 
                                    else {
            throw Abort(.notFound, reason: "Category not found")
        }

        return (user, category)
    }

}
