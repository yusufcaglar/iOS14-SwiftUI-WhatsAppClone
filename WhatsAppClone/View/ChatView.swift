//
//  ChatView.swift
//  WhatsAppClone
//
//  Created by Yusuf ÇAĞLAR on 24/03/2021.
//

import SwiftUI
import Firebase

struct ChatView: View {
    
    let db = Firestore.firestore()
    var userToChat: UserModel
    @State var message = ""
    @ObservedObject var chatStore = ChatStore()
    
    var body: some View {
        VStack {
            
            ScrollView {
                ForEach(chatStore.chatArray) { chats in
                    ChatRow(chatMessage: chats, chatUser: userToChat)
                }
            }
            
            HStack {
                TextField("Message", text: $message)
                Button(action: sendMessage) {
                    Text("Send")
                }
            }.frame(minHeight: 48)
            .padding()
        }
    }
    
    func sendMessage() {
        
        let ref = db.collection("chats")
        
        ref.addDocument(data: [
            "sender": Auth.auth().currentUser?.uid,
            "receiver": userToChat.userID,
            "message": message,
            "date": Date().timeIntervalSince1970
        ]) { (error) in
            if let e = error {
                print("There's an error sending message. \(e.localizedDescription)")
            } else {
                self.message = ""
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(userToChat: UserModel(id: 0, name: "Brian", userID: "sadf123213sdf"))
    }
}
