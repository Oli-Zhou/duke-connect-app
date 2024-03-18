# ECE564 Project - New Bee - Backend Server

## Comment
### GET
`/comments?event_id={eventid}`

return: [CommentDTO]

struct CommentDTO: {

    var id: UUID?
    var upperComment: UUID?
    var eventid: String
    var userid: String
    var content: String
    var time: Date
}
### POST
`/comments`

Body: CommentDTO

### DELETE
`/comments/{commentID}`

## User-Category
### GET
`/user-categories/categories?username={username}`

### POST
`/user-categories/add?username={username}&category={category}`

### DELETE
`/user-categories/remove?username={username}&category={category}`

## User
### GET
`/users`

return [User]

struct User: {

    var id: UUID
    var name: String
    var avatar: String?
}

### POST
`/users`

`/users/updateAvatar`

Body: UserDTO

struct UserDTO: {

    var name: String
    var avatar: String?
}
### DELETE
`/users/{userID}`

## User-Event
### GET
`/user-events/events?username={username}`

return: [String]

`/user-events/userNum?eventid={eventid}`

return: Int

`/user-events/eventContent?eventid={eventid}`

return: EventDTO

struct EventDTO: {

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

enum EventStatus: {

    case confirmed = "CONFIRMED"
    case cancelled = "CANCELLED"
    case tentative = "TENTATIVE"
}

struct Location: {

    var address: String
    var link: String?
}

struct Contact: {

    var name: String
    var phone: String?
    var email: String?
}

### POST
`/user-events/add?username={username}&eventid={eventid}`

### DELETE
`/user-events/remove?username={username}&eventid={eventid}`

## User-Group
### GET
`/user-groups/groups?username={username}`

return: [String]

### POST
`/user-groups/add?username={username}&groupname={groupname}`

### DELETE
`/user-groups/remove?username={username}&groupname={groupname}`
