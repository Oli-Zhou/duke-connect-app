//
//  CategoryTag.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/13/23.
//

import SwiftUI

struct CategoryTag: View {
    let category: String
    var fontSize: Int
    var theme:Theme{
        Theme[Int(category.getSize())]
    }
    var body: some View {
        Text(category)
            .foregroundColor(theme.accentColor)
            .font(.system(size: CGFloat(fontSize)))
            .padding(.leading, 14)
            .padding(.trailing, 14)
            .padding(.vertical, 8)
            .background(
                ZStack(alignment: .trailing) {
                    Capsule()
                        .fill(theme.mainColor)
                }
            )
    }
}

#Preview {
    CategoryTag(category: "asdasdas", fontSize: 16)
}
