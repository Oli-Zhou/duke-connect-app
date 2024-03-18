import Fluent
import Vapor
final class UserCategory: Model {
    static let schema = "user_category"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "userId")
    var user: User

    @Parent(key: "categoryId")
    var category: Category

    init() { }

    init(id: UUID? = nil, userId: UUID, categoryId: UUID) {
        self.id = id
        self.$user.id = userId
        self.$category.id = categoryId
    }
}