//
//  FloatingWindow.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/20/23.
//

import SwiftUI

struct FloatingWindow: View {
    var msg: String
    var body: some View {
        VStack {
            Text(msg)
                .fontWeight(.heavy)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                //.transition(.move(edge: .bottom))
    }
}

#Preview {
    FloatingWindow(msg: "Comment published")
}
