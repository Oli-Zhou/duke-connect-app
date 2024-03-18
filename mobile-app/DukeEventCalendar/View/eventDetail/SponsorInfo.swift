//
//  SponsorInfo.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/18/23.
//

import SwiftUI

struct SponsorInfo: View {
    @State var showCoSponsors = false
    var user: User
    var sponsor: String
    var co_sponsors: [String]?
    
    var body: some View {
        HStack {
            Text("By")
            NavigationLink(destination: groupDetail(group: sponsor)) {
                Text(sponsor).multilineTextAlignment(.leading)
                    .underline().scaledToFit()
            }
            
            if co_sponsors != nil {
                if showCoSponsors {
                    Text(",")
                }
                else {
                    Button("+ \(co_sponsors!.count)") {
                        showCoSponsors.toggle()
                    }
                }
            }
        }
        VStack(alignment: .leading) {
            if showCoSponsors {
                ForEach(co_sponsors!, id: \.self) { sp in
                    HStack(alignment: .bottom) {
                        NavigationLink(
                            destination: groupDetail(group: sp)
                        ) {
                            Text("\(sp)").multilineTextAlignment(.leading)
                                .underline()
                        }
                        if sp != co_sponsors!.last {
                            Text(",")
                        }
                    }
                }
                HStack{
                    Spacer()
                    Button("Hide") {
                        showCoSponsors.toggle()
                    }
                    .padding(.trailing, 20.0)
                }
            }
        }.padding(.leading, 28.0)
    }
}

#Preview {
    SponsorInfo(user: User.sampleUser, sponsor: sample_event.sponsor, co_sponsors: sample_event.co_sponsors)
}
