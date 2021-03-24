//
//  ChatStore.swift
//  WhatsAppClone
//
//  Created by Yusuf ÇAĞLAR on 25/03/2021.
//

import SwiftUI
import Firebase
import Combine

class ChatStore: ObservableObject {
    
    let db = Firestore.firestore()
    var chatArray: [ChatModel] = []
    
    var objectWillChange = PassthroughSubject<Array<Any>, Never>()
    
    init() {
        
        db.collection("chats")
            .order(by: "date", descending: true)
            .whereField("sender", isEqualTo: Auth.auth().currentUser?.uid)
            .addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There's an error receiving message data from firestore. \(e.localizedDescription)")
            } else {
                
                self.chatArray.removeAll()
                
                guard let snapshotDocuments = querySnapshot?.documents else {
                    return
                }
                
                for document in snapshotDocuments {
                    
                    let data = document.data()
                    
                    let messageDocID = document.documentID
                    
                    guard let message = data["message"] as? String else {
                        return
                    }
                    
                    guard let receiver = data["receiver"] as? String else {
                        return
                    }
                    
                    guard let sender = data["sender"] as? String else {
                        return
                    }
                    
                    guard let date = data["date"] as? Double else {
                        return
                    }
                    
                    let currentIndex = self.chatArray.last?.id
                                         
                    let chat = ChatModel(id: (currentIndex ?? -1) + 1, message: message, messageDocID: messageDocID, sender: sender, receiver: receiver, date: date)
                    
                    self.chatArray.append(chat)
                }
                
                self.db.collection("chats")
                    .order(by: "date", descending: true)
                    .whereField("receiver", isEqualTo: Auth.auth().currentUser?.uid)
                    .addSnapshotListener { (querySnapshot, error) in
                    if let e = error {
                        print("There's an error receiving message data from firestore. \(e.localizedDescription)")
                    } else {
                        
                        guard let snapshotDocuments = querySnapshot?.documents else {
                            return
                        }
                        
                        for document in snapshotDocuments {
                            
                            let data = document.data()
                            
                            let messageDocID = document.documentID
                            
                            guard let message = data["message"] as? String else {
                                return
                            }
                            
                            guard let receiver = data["receiver"] as? String else {
                                return
                            }
                            
                            guard let sender = data["sender"] as? String else {
                                return
                            }
                            
                            guard let date = data["date"] as? Double else {
                                return
                            }
                            
                            let currentIndex = self.chatArray.last?.id
                                                 
                            let chat = ChatModel(id: (currentIndex ?? -1) + 1, message: message, messageDocID: messageDocID, sender: sender, receiver: receiver, date: date)
                            
                            self.chatArray.append(chat)
                        }
                        
                        self.objectWillChange.send(self.chatArray)
                    }
                }
            }
        }
    }
}
