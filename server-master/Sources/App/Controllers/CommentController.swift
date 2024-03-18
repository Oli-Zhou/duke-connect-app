import Vapor
import Fluent

struct CommentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let comments = routes.grouped("comments")
        comments.get(use: getComments) 
        comments.post(use: createComment) 
        comments.delete(":commentID", use: deleteComment) 
    }

    func createComment(req: Request) async throws -> Comment {
        print(req.content)
        let commentDTO = try req.content.decode(CommentDTO.self)
        //print("test")
        let comment = Comment(commentDTO)
        try await comment.save(on: req.db)
        return comment
    }

    func getComments(req: Request) async throws -> [CommentDTO] {
        guard let eventID = req.query[String.self, at: "event_id"] else {
            throw Abort(.badRequest)
        }
        let comments = try await Comment.query(on: req.db)
                                        .filter(\.$eventid == eventID)
                                        .all()
        let commentDTOs = comments.map { comment in
            CommentDTO(id: comment.id, 
                    upperComment: comment.$upperComment.id, 
                    eventid: comment.eventid, 
                    userid: comment.userid, 
                    content: comment.content, 
                    time: comment.time)
        }

        return commentDTOs
    }

    func deleteComment(req: Request) async throws -> HTTPStatus {
        guard let commentID = req.parameters.get("commentID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        guard let comment = try await Comment.find(commentID, on: req.db) else {
            throw Abort(.notFound)
        }

        try await comment.delete(on: req.db)
        return .ok
    }

}
