//
//  utility.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import CoreLocation
import Foundation
import UIKit

func geocodeLocation(address: String, completion: @escaping (CLPlacemark?, Error?) -> Void) {
    let geocoder = CLGeocoder()

    geocoder.geocodeAddressString(address) { (placemarks, error) in
        if let error = error {
            print("Geocoding failed with error: \(error)")
            completion(nil, error)
        }
        else if let placemark = placemarks?.first {
            completion(placemark, nil)
        }
        else {
            print("No placemarks found for the given address")
            completion(nil, nil)
        }
    }
}

//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
//    dateFormatter.timeZone = TimeZone(identifier: "UTC") // Set the time zone to UTC
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale
//
//    let start = dateFormatter.date(from: "2023-10-01T04:00:00Z")
//    let end = dateFormatter.date(from: "2024-06-30T04:00:00Z")
//
//    let loc = Location(addr: "Durham, NC")

//    let event = Event(id: "CAL-2c918083-7bf1eaed-017c-150f18e4-0000595cdemobedework@mysite.edu_20231001T040000Z", start: start!, end: end!, summary: "Doing Good Employee Giving Campaign", description: "Doing Good, Duke's annual employee giving campaign, encourages Duke employees to donate to five community-identified need categories, including the United Way of the Greater Triangle. Employees can make tax-deductible donations year-round which create big impacts for community organizations in the region. Learn more or donate at doinggood.duke.edu.", status: EventStatus.confirmed, sponsor: "Office of Durham and Community Affairs", loc: loc, contact: <#T##Contact#>)

func sampleEvent() -> [Event]? {
    let url = Bundle.main.url(forResource: "sample_5", withExtension: "json")
    do {
        let data = try Data(contentsOf: url!)
        let decoder = JSONDecoder()
        let events = try decoder.decode([String: [Event]].self, from: data)
        let events_list = events["events"]
        return events_list
    }
    catch let error as NSError {
        print(error)
        return nil
    }
}

let sampleEvents = sampleEvent()
let sample_event = sampleEvents![0]

func dateToString(time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let date_time_str = dateFormatter.string(from: time)
    return date_time_str
}

func dateToStringDate(time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date_str = dateFormatter.string(from: time)
    return date_str
}

func dateToStringTime(time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let time_str = dateFormatter.string(from: time)
    return time_str
}

func getFormattedDate(time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: time)
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width
}

extension String {
    func getSize() -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
}

let sampleComment = Comment(
    eventid: sample_event.id,
    userid: "aoli",
    content: "This is a comment.",
    time: .now
)

func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}

//Source: https://developer.apple.com/forums/thread/67564?answerId=195171022#195171022
func jpegImage(image: UIImage, maxSize: Int, minSize: Int, times: Int) -> Data? {
    var maxQuality: CGFloat = 1.0
    var minQuality: CGFloat = 0.0
    var bestData: Data?
    for _ in 1...times {
        let thisQuality = (maxQuality + minQuality) / 2
        guard let data = image.jpegData(compressionQuality: thisQuality) else { return nil }
        let thisSize = data.count
        if thisSize > maxSize {
            maxQuality = thisQuality
        }
        else {
            minQuality = thisQuality
            bestData = data
            if thisSize > minSize {
                return bestData
            }
        }
    }

    return bestData
}
