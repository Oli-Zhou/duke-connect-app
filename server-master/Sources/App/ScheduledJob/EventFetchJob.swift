import Vapor
import Queues
struct EventFetchJob: AsyncScheduledJob{

    func run(context: QueueContext) async throws{
        do {
            let events = try await fetchEvents(from: "https://calendar.duke.edu/events/index.json?&future_days=90&feed_type=simple", app: context.application)
            print(events.count)
            print(events[0])
            try await updateEventsInDatabase(events: events, app: context.application)
        } catch {
            print("Error fetching or updating events: \(error)")
        }
    }
}

func fetchEvents(from url: String, app: Application) async throws -> [EventDTO] {
    let response = try await app.client.get(URI(string: url))
    guard let body = response.body else {
        throw Abort(.badRequest, reason: "No data in response")
    }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let eventsResponse = try decoder.decode(EventsResponse.self, from: Data(buffer: body))
    return eventsResponse.events
}

func updateEventsInDatabase(events: [EventDTO], app: Application) async throws {
    for eventDTO in events {
        if let existingEvent = try await Event.find(eventDTO.id, on: app.db) {
            if existingEvent.shouldUpdate(with: eventDTO) {
                existingEvent.update(from: eventDTO)
                try await existingEvent.update(on: app.db)
            }
        } else {
            let newEvent = Event(from: eventDTO)
            try await newEvent.save(on: app.db)
        }
    }
}
