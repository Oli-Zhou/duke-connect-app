//
//  LogInPage.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/21/23.
//

import SwiftUI

struct LogInPage: View {
    @EnvironmentObject var datamodel: DataModel
    @EnvironmentObject var user: User
    @State var userName = ""
    @State var msg = ""

    var body: some View {
        ZStack {
            Image("background").resizable().aspectRatio(contentMode: .fill).padding(.trailing, 20)

            VStack {
                TextField("", text: $userName, prompt: Text("Enter username"))
                    .disableAutocorrection(true)
                    .frame(width: 350, height: 20.0)
                    .textFieldStyle(.roundedBorder)
                    .padding(.all)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.blue).frame(width: 80, height: 40)
                    Button("log in") {
                        loginOrSignUp()
                        hideKeyboard()
                    }
                    .foregroundColor(.white).fontWeight(.heavy)
                }
                Text(msg)

            }
            .padding(.top, 200.0)
            .padding(.horizontal, 30)
        }

    }

    private func loginOrSignUp() {
        if userName.count == 0 {
            msg = "Username cannot be empty"
            return
        }
        let userDTO = UserDTO(name: userName)

        createUser(userDTO) { result, error in
            if result != nil {
                DispatchQueue.main.async {
                    user.userid = userName
                    user.picture = result!.avatar
                    print("user picture size: \(String(describing: user.picture?.count))")
                    user.isLoggedin = true
                }
            }
            else if let error = error {
                DispatchQueue.main.async {
                    msg = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    LogInPage()
        .environmentObject(DataModel())
        .environmentObject(User())
}
