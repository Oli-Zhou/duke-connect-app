//
//  GroupTag.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/18/23.
//

import SwiftUI

struct GroupTag: View {
    let group: String
    var fontSize: Int
    var theme:Theme{
        Theme[Int(group.getSize())]
    }
    var body: some View {
        Text(group)
            .underline()
            .foregroundColor(theme.accentColor)
            .font(.system(size: CGFloat(fontSize)))
            .padding(.leading, 14)
            .padding(.trailing, 14)
            .padding(.vertical, 8)
            .background(
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .fill(theme.mainColor)
                }
            )
    }
}

#Preview {
    GroupTag(group: "hihihihiiii", fontSize: 16)
}
