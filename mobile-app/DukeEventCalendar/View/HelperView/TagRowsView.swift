//
//  TagRowsView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/14/23.
//

import SwiftUI

//Static TagRowsView
struct TagRowsView: View {
    @ObservedObject var tagRows: TagRows
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tagRows.rows, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(row) { tag in
                            CategoryTag(category: tag.name, fontSize: 16)
                        }
                    }
                    .frame(height: 28)
                    .padding(.bottom, 10)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    TagRowsView(tagRows: TagRows.suggestedCategoriesTagRows)
}
