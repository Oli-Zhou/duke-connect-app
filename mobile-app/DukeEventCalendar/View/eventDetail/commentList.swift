//
//  commentList.swift
//  New Bee
//
//  Created by Oli 奥利奥 on 10/29/23.
//

import SwiftUI

struct commentList: View {
    @ObservedObject var event: Event
    @EnvironmentObject var datamodel: DataModel
    @Binding var replyTo: Comment?
    let userid: String
    let eventid: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(event.comments.count) comments")
                .font(.system(size: 15))
                .foregroundColor(Color.blue)
                .padding(.leading)

            ForEach(event.mainComments, id: \.self) { comment in
                singleComment(event: event, replyTo: $replyTo, comment: comment, userid: userid)
                ForEach(event.getSubComments(cmtid: comment.id), id: \.self) { subComment in
                    singleComment(
                        event: event,
                        replyTo: $replyTo,
                        comment: subComment,
                        userid: userid
                    )
                    .padding(.leading, 30.0)
                }
                Divider()
                    .background(Color.gray)
            }
        }
    }
}

#Preview {
    commentList(
        event: DataModel.sampleEvents![0],
        replyTo: .constant(nil),
        userid: "aoli",
        eventid: sample_event.id
    )
    .environmentObject(DataModel())
}
