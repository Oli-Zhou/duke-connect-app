//
//  FetchServer.swift
//  DukeEventCalendar
//
//  Created by Fall2023 on 11/23/23.
//

import Foundation

let serverURL = "http://vcm-35987.vm.duke.edu:8080"

func fetchComments(forEventID eventID: String, completion: @escaping ([Comment]?, Error?) -> Void) {
    guard let url = URL(string: "\(serverURL)/comments?event_id=\(eventID)") else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    URLSession.shared
        .dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            //print(String(data: data, encoding: .utf8)!)//***** data have no uppercomment attribute
            let comments = try? JSONDecoder().decode([Comment].self, from: data)
            completion(comments, nil)
        }
        .resume()
}

func createComment(_ comment: Comment, completion: @escaping (Comment?, Error?) -> Void) {
    guard let url = URL(string: "\(serverURL)/comments") else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONEncoder().encode(comment)
    //print(String(data: try! JSONEncoder().encode(comment), encoding: .utf8)!)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared
        .dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            let createdComment = try? JSONDecoder().decode(Comment.self, from: data)
            completion(createdComment, nil)
        }
        .resume()
}

func deleteComment(withID commentID: UUID, completion: @escaping (Bool, Error?) -> Void) {
    guard let url = URL(string: "\(serverURL)/comments/\(commentID.uuidString)") else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    URLSession.shared
        .dataTask(with: request) { _, _, error in
            if let error = error {
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
        .resume()
}

func fetchGroups(forUser userName: String, completion: @escaping ([String]?, Error?) -> Void) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString = "\(serverURL)/user-groups/groups?username=\(encodedUserName)"

    guard let url = URL(string: urlString) else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    URLSession.shared
        .dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            let groupNames = try? JSONDecoder().decode([String].self, from: data)
            completion(groupNames, nil)
        }
        .resume()
}

func addUserToGroup(
    userName: String,
    groupName: String,
    completion: @escaping (Bool, Error?) -> Void
) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ),
        let encodedGroupName = groupName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString =
        "\(serverURL)/user-groups/add?username=\(encodedUserName)&groupname=\(encodedGroupName)"

    guard let url = URL(string: urlString) else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    URLSession.shared
        .dataTask(with: request) { _, _, error in
            if let error = error {
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
        .resume()
}

func removeUserFromGroup(
    userName: String,
    groupName: String,
    completion: @escaping (Bool, Error?) -> Void
) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ),
        let encodedGroupName = groupName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString =
        "\(serverURL)/user-groups/remove?username=\(encodedUserName)&groupname=\(encodedGroupName)"

    guard let url = URL(string: urlString) else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    URLSession.shared
        .dataTask(with: request) { _, _, error in
            if let error = error {
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
        .resume()
}

func fetchCategories(forUser userName: String, completion: @escaping ([String]?, Error?) -> Void) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString = "\(serverURL)/user-categories/categories?username=\(encodedUserName)"

    guard let url = URL(string: urlString) else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    URLSession.shared
        .dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            let categoryNames = try? JSONDecoder().decode([String].self, from: data)
            completion(categoryNames, nil)
        }
        .resume()
}

func addUserToCategory(
    userName: String,
    categoryName: String,
    completion: @escaping (Bool, Error?) -> Void
) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ),
        let encodedCategoryName = categoryName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString =
        "\(serverURL)/user-categories/add?username=\(encodedUserName)&categoryname=\(encodedCategoryName)"

    guard let url = URL(string: urlString) else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    URLSession.shared
        .dataTask(with: request) { _, _, error in
            if let error = error {
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
        .resume()
}

func removeUserFromCategory(
    userName: String,
    categoryName: String,
    completion: @escaping (Bool, Error?) -> Void
) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ),
        let encodedCategoryName = categoryName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString =
        "\(serverURL)/user-categories/remove?username=\(encodedUserName)&categoryname=\(encodedCategoryName)"

    guard let url = URL(string: urlString) else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    URLSession.shared
        .dataTask(with: request) { _, _, error in
            if let error = error {
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
        .resume()
}

struct UserDTO: Codable {
    let name: String
    var avatar: String?
}

func createUser(_ userDTO: UserDTO, completion: @escaping (UserDTO?, Error?) -> Void) {
    guard let url = URL(string: "\(serverURL)/users") else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONEncoder().encode(userDTO)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared
        .dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let userDTO = try? JSONDecoder().decode(UserDTO.self, from: data)
            completion(userDTO, nil)
        }
        .resume()
}

func fetchEvents(forUser userName: String, completion: @escaping ([String]?, Error?) -> Void) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString = "\(serverURL)/user-events/events?username=\(encodedUserName)"

    guard let url = URL(string: urlString) else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    URLSession.shared
        .dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            let eventids = try? JSONDecoder().decode([String].self, from: data)
            completion(eventids, nil)
        }
        .resume()
}

func addUserEvent(userName: String, eventid: String, completion: @escaping (Bool, Error?) -> Void) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ),
        let encodedEventId = eventid.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString =
        "\(serverURL)/user-events/add?username=\(encodedUserName)&eventid=\(encodedEventId)"

    guard let url = URL(string: urlString) else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    URLSession.shared
        .dataTask(with: request) { _, _, error in
            if let error = error {
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
        .resume()
}

func removeUserEvent(
    userName: String,
    eventid: String,
    completion: @escaping (Bool, Error?) -> Void
) {
    guard
        let encodedUserName = userName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ),
        let encodedEventId = eventid.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    let urlString =
        "\(serverURL)/user-events/remove?username=\(encodedUserName)&eventid=\(encodedEventId)"

    guard let url = URL(string: urlString) else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    URLSession.shared
        .dataTask(with: request) { _, _, error in
            if let error = error {
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
        .resume()
}

func updateUserAvatar(_ userDTO: UserDTO, completion: @escaping (Bool, Error?) -> Void) {
    guard let url = URL(string: "\(serverURL)/users/updateAvatar") else {
        completion(false, NSError(domain: "", code: -1, userInfo: nil))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONEncoder().encode(userDTO)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared
        .dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            guard let _ = data else {
                completion(false, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            completion(true, nil)
        }
        .resume()
}

func getEventInterestedUserNum(_ eventID: String, completion: @escaping (Int, Error?) -> Void) {
    guard let url = URL(string: "\(serverURL)/user-events/userNum?eventid=\(eventID)") else {
        completion(-1, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    URLSession.shared
        .dataTask(with: url) { data, response, error in
            if let error = error {
                completion(-1, error)
                return
            }
            guard let data = data else {
                completion(-1, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            guard let num = try? JSONDecoder().decode(Int.self, from: data) else {
                completion(-1, NSError(domain: "", code: -1, userInfo: nil))
                return

            }
            return completion(num, nil)
        }
        .resume()

}

func getEventContent(_ eventID: String, completion: @escaping (Event?, Error?) -> Void) {
    guard let url = URL(string: "\(serverURL)/user-events/eventContent?eventid=\(eventID)") else {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
        return
    }

    URLSession.shared
        .dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            guard let event = try? JSONDecoder().decode(Event.self, from: data) else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return

            }
            return completion(event, nil)
        }
        .resume()
}
