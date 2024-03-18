import Fluent
import Vapor

final class Event: Model, Content {
    static let schema = "events"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Field(key: "start_timestamp")
    var startTimestamp: Date

    @Field(key: "end_timestamp")
    var endTimestamp: Date

    @Field(key: "summary")
    var summary: String

    @Field(key: "description")
    var description: String

    @Enum(key: "status")
    var status: EventStatus

    @Field(key: "sponsor")
    var sponsor: String

    @OptionalField(key: "co_sponsors")
    var coSponsors: [String]?

    @Field(key: "location_address")
    var locationAddress: String

    @Field(key: "location_link")
    var locationLink: String?

    @Field(key: "contact_name")
    var contactName: String

    @Field(key: "contact_phone")
    var contactPhone: String?

    @Field(key: "contact_email")
    var contactEmail: String?

    @OptionalField(key: "categories")
    var categories: [String]?

    @Field(key: "submitted_by")
    var submittedBy: [String]

    @OptionalField(key: "presenter")
    var presenter: String?

    @OptionalField(key: "image_alt_text")
    var imageAltText: String?

    @Field(key: "link")
    var link: String

    @OptionalField(key: "event_url")
    var eventUrl: String?

    @OptionalField(key: "image")
    var image: String?

    init() {}

    init(id: String? = nil, startTimestamp: Date, endTimestamp: Date, summary: String, description: String, status: EventStatus, sponsor: String, coSponsors: [String]?, location: Location, contact: Contact, categories: [String]?, link: String, eventUrl: String?, submittedBy: [String], presenter: String?, image: String?, imageAltText: String?) {
        self.id = id
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.summary = summary
        self.description = description
        self.status = status
        self.sponsor = sponsor
        self.coSponsors = coSponsors
        self.locationAddress = location.address
        self.locationLink = location.link
        self.contactName = contact.name
        self.contactPhone = contact.phone
        self.contactEmail = contact.email
        self.categories = categories
        self.link = link
        self.eventUrl = eventUrl
        self.submittedBy = submittedBy
        self.presenter = presenter
        self.image = image
        self.imageAltText = imageAltText
    }

    init(eventDTO: EventDTO){
        self.id = eventDTO.id
        self.startTimestamp = eventDTO.start_timestamp
        self.endTimestamp = eventDTO.end_timestamp
        self.summary = eventDTO.summary
        self.description = eventDTO.description
        self.status = eventDTO.status
        self.sponsor = eventDTO.sponsor
        self.coSponsors = eventDTO.co_sponsors
        self.locationAddress = eventDTO.location.address
        self.locationLink = eventDTO.location.link
        self.contactName = eventDTO.contact.name
        self.contactPhone = eventDTO.contact.phone
        self.contactEmail = eventDTO.contact.email
        self.categories = eventDTO.categories
        self.link = eventDTO.link
        self.eventUrl = eventDTO.event_url
        self.submittedBy = eventDTO.submitted_by
        self.presenter = eventDTO.presenter
        self.image = eventDTO.image
        self.imageAltText = eventDTO.image_alt_text
    }
}

enum EventStatus: String, Codable {
    case confirmed = "CONFIRMED"
    case cancelled = "CANCELLED"
    case tentative = "TENTATIVE"
}
struct Location: Codable {
    var address: String
    var link: String?
}

struct Contact: Codable {
    var name: String
    var phone: String?
    var email: String?
}

struct EventDTO: Content{
    var id: String
    var start_timestamp: Date
    var end_timestamp: Date
    var summary: String
    var description: String
    var status: EventStatus
    var sponsor: String
    var co_sponsors: [String]?
    var location: Location
    var contact: Contact
    var categories: [String]?
    var link: String
    var event_url: String?
    var submitted_by: [String]
    var presenter: String?
    var image: String?
    var image_alt_text: String?
}

struct EventsResponse: Codable {
    let events: [EventDTO]
}

extension Event {
    func shouldUpdate(with eventDTO: EventDTO) -> Bool {
        return self.startTimestamp != eventDTO.start_timestamp ||
               self.endTimestamp != eventDTO.end_timestamp ||
               self.summary != eventDTO.summary ||
                self.description != eventDTO.description ||
                self.status != eventDTO.status ||
                self.sponsor != eventDTO.sponsor ||
                self.coSponsors != eventDTO.co_sponsors ||
                self.locationAddress != eventDTO.location.address ||
                self.locationLink != eventDTO.location.link ||
                self.contactName != eventDTO.contact.name ||
                self.contactPhone != eventDTO.contact.phone ||
                self.contactEmail != eventDTO.contact.email ||
                self.categories != eventDTO.categories ||
                self.link != eventDTO.link ||
                self.eventUrl != eventDTO.event_url ||
                self.submittedBy != eventDTO.submitted_by ||
                self.presenter != eventDTO.presenter ||
                self.image != eventDTO.image ||
                self.imageAltText != eventDTO.image_alt_text
    }

    func update(from eventDTO: EventDTO) {
        self.startTimestamp = eventDTO.start_timestamp
        self.endTimestamp = eventDTO.end_timestamp
        self.summary = eventDTO.summary
        self.description = eventDTO.description
        self.status = eventDTO.status
        self.sponsor = eventDTO.sponsor
        self.coSponsors = eventDTO.co_sponsors
        self.locationAddress = eventDTO.location.address
        self.locationLink = eventDTO.location.link
        self.contactName = eventDTO.contact.name
        self.contactPhone = eventDTO.contact.phone
        self.contactEmail = eventDTO.contact.email
        self.categories = eventDTO.categories
        self.link = eventDTO.link
        self.eventUrl = eventDTO.event_url
        self.submittedBy = eventDTO.submitted_by
        self.presenter = eventDTO.presenter
        self.image = eventDTO.image
        self.imageAltText = eventDTO.image_alt_text
    }

    convenience init(from eventDTO: EventDTO) {
        self.init()
        self.id = eventDTO.id
        self.update(from: eventDTO)
    }
}