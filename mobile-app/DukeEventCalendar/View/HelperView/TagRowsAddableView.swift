//
//  TagRowsView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/13/23.
//

import SwiftUI


//Shows group or category tags
//On click Tag: add to tagRowsSaved.
struct TagRowsAddableView: View {
    let tagType:TagType
    @ObservedObject var tagRows: TagRows
    @ObservedObject var tagRowsSaved: TagRows
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tagRows.rows, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(row) { tag in
                            Button {
                                withAnimation {
                                    tagRowsSaved.addTag(tag: tag)
                                }
                            } label: {
                                if(tagType == .Category){
                                    CategoryTag(category: tag.name, fontSize: 16)
                                }else{
                                    GroupTag(group: tag.name, fontSize: 16)
                                }
                                
                            }
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
    TabView{
        TagRowsAddableView(tagType:.Category,tagRows: TagRows.categoriesTagRows, tagRowsSaved: TagRows())
            .tabItem { Text("category") }
        TagRowsAddableView(tagType: .Group, tagRows: TagRows.groupTagRows, tagRowsSaved: TagRows())
            .tabItem { Text("group") }
    }
}
