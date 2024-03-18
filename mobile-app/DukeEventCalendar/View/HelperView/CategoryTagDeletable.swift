//
//  CategoryTagDeletable.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/14/23.
//

import SwiftUI

//just the capsule with the delete symbol
struct CategoryTagDeletable: View {
    let category: String
    var theme: Theme {
        Theme[Int(category.getSize())]
    }
    var body: some View {
        Text(category)
            .foregroundColor(theme.accentColor)
            .font(.system(size: 16))
            .padding(.leading, 14)
            .padding(.trailing, 14)
            .padding(.vertical, 8)
            .background(
                ZStack(alignment: .trailing) {
                    Capsule()
                        .fill(theme.mainColor)
                    Image(systemName: "multiply.circle.fill")
                        .padding(.trailing, -10)
                        .padding(.top, -20)
                        .foregroundColor(.red)
                }
            )
    }
}

#Preview {
    CategoryTagDeletable(category: "asdadf")
}
