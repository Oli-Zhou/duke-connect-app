//
//  SearchBarView.swift
//  DukeEventCalendar
//
//  Created by xz353 on 11/14/23.
//

import SwiftUI

//source: https://stackoverflow.com/a/76832590
struct SearchBarView: View {
    let searchFieldDefault: String
    @Binding var searchText: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField(
                    searchFieldDefault,
                    text: $searchText
                )
            }
            .padding(7)
            .background(Color(white: 0.9))
            .cornerRadius(10)
            if searchText != "" {
                Button("Clear") {
                    withAnimation {
                        searchText = ""
                    }
                }
            }
        }
    }
}

#Preview {
    SearchBarView(searchFieldDefault: "hi", searchText: .constant("ok"))
}
