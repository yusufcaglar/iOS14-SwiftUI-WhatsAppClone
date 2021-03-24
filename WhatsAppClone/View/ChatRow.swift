//
//  ChatRow.swift
//  WhatsAppClone
//
//  Created by Yusuf ÇAĞLAR on 25/03/2021.
//

import SwiftUI
import Firebase

struct ChatRow: View {
    
    var chatMessage: ChatModel
    var chatUser: UserModel
    
    var body: some View {
        
        Group {
            if chatMessage.sender == Auth.auth().currentUser?.uid && chatMessage.receiver == chatUser.userID {
                HStack {
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(.blue)
                        .padding(8)
                    Spacer()
                }
            } else if chatMessage.sender == chatUser.userID && chatMessage.receiver == Auth.auth().currentUser?.uid {
                HStack {
                    Spacer()
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(.blue)
                        .padding(8)
                }
            } else {
                
            }
        }.frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chatMessage: ChatModel(id: 0, message: "dope", messageDocID: "sdf", sender: "nope", receiver: "dang", date: 10.2), chatUser: UserModel(id: 1, name: "jack", userID: "234"))
    }
}
