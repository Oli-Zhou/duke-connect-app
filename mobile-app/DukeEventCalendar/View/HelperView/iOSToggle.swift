//
//  iOSToggle.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/13/23.
//

import SwiftUI

//Source: https://sarunw.com/posts/swiftui-checkbox/
struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    configuration.label
                }
            }
        )
    }
}
