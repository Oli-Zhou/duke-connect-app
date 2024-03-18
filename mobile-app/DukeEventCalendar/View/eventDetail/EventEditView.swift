//
//  eventEditView.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/1/23.
//
// adapted from https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/discover-calendar-and-eventkit

import SwiftUI
import EventKitUI

struct EventEditViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    typealias UIViewControllerType = EKEventEditViewController
    
    let dukeEvent:Event
    
    private let store = EKEventStore()
    private var event: EKEvent {
        let event = EKEvent(eventStore: store)
        event.title = dukeEvent.summary
        event.startDate = Calendar.current.date(from: dukeEvent.calendarStartDate)
        event.endDate = Calendar.current.date(from: dukeEvent.calendarEndDate)
        event.location = dukeEvent.location.address
        event.notes = dukeEvent.description
        return event
    }
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = event
        eventEditViewController.eventStore = store
        eventEditViewController.editViewDelegate = context.coordinator
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditViewController
        
        init(_ controller: EventEditViewController) {
            self.parent = controller
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
