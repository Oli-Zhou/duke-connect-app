import Vapor
import Fluent

struct UserEventController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userEvents = routes.grouped("user-events")
        userEvents.get("events", use: getEventsForUser)
        userEvents.post("add", use: addUserToEvent)
        userEvents.delete("remove", use: removeUserFromEvent)
        userEvents.get("userNum", use: getInterestedNumber)
        userEvents.get("eventContent", use: getEventContent)
    }

    func getEventsForUser(req: Request) async throws -> [String] {
        guard let userName = req.query[String.self, at: "username"] else {
            throw Abort(.badRequest)
        }

        guard let user = try await User.query(on: req.db)
                                .filter(\.$name == userName)
                                .first() else {
            throw Abort(.notFound)
        }

        let userEvents = try await UserEvent.query(on: req.db)
                                            .filter(\.$user.$id == user.id!)
                                            .all()
        return userEvents.map(\.eventid)
    }

    func addUserToEvent(req: Request) async throws -> HTTPStatus {
        guard let userName = req.query[String.self, at: "username"],
              let eventID = req.query[String.self, at: "eventid"] else {
            throw Abort(.badRequest)
        }

        guard let user = try await User.query(on: req.db)
                                .filter(\.$name == userName)
                                .first() else {
            throw Abort(.notFound)
        }

        let userEvent = UserEvent(userId: user.id!, eventid: eventID)
        try await userEvent.save(on: req.db)
        return .ok
    }

    func removeUserFromEvent(req: Request) async throws -> HTTPStatus {
        guard let userName = req.query[String.self, at: "username"],
              let eventID = req.query[String.self, at: "eventid"] else {
            throw Abort(.badRequest)
        }

        guard let user = try await User.query(on: req.db)
                                .filter(\.$name == userName)
                                .first() else {
            throw Abort(.notFound)
        }

        try await UserEvent.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$eventid == eventID)
            .delete()
        return .ok
    }

    func getInterestedNumber(req: Request) async throws -> Int {
        guard let eventID = req.query[String.self, at: "eventid"] else{
            throw Abort(.badRequest)
        }
        let userEventsNumber = try await UserEvent.query(on: req.db)
                                            .filter(\.$eventid == eventID)
                                            .count()
        return userEventsNumber
    }

    func getEventContent(req: Request) async throws -> EventDTO {
        guard let eventID = req.query[String.self, at: "eventid"] else{
            throw Abort(.badRequest)
        }
        guard let event = try await Event.query(on: req.db)
                                        .filter(\.$id == eventID)
                                        .first() else{
            throw Abort(.notFound)
        }
        let eventDTO = EventDTO(id: eventID, 
                                start_timestamp: event.startTimestamp, 
                                end_timestamp: event.endTimestamp,
                                summary: event.summary,
                                description: event.description,
                                status: event.status,
                                sponsor: event.sponsor,
                                co_sponsors: event.coSponsors,
                                location: Location(address: event.locationAddress, link: event.locationLink),
                                contact: Contact(name: event.contactName, phone: event.contactPhone, email: event.contactEmail),
                                categories: event.categories,
                                link: event.link,
                                event_url: event.eventUrl,
                                submitted_by: event.submittedBy,
                                presenter: event.presenter,
                                image: event.image,
                                image_alt_text: event.imageAltText);
        return eventDTO
    }
}
