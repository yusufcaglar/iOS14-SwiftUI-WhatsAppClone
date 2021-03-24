//
//  UserStore.swift
//  WhatsAppClone
//
//  Created by Yusuf ÇAĞLAR on 24/03/2021.
//

import SwiftUI
import Firebase
import Combine

class UserStore: ObservableObject {
    
    let db = Firestore.firestore()
    var userArray: [UserModel] = []
    var objectWillChange = PassthroughSubject<Array<Any>,Never>()
    
    init() {
        db.collection("users").addSnapshotListener { (querysnapshot, error) in
            if let e = error {
                print("There's an error receiving users from firestore, \(e.localizedDescription)")
            } else {
                
                self.userArray.removeAll()
                
                guard let snapshotDocuments = querysnapshot?.documents else {
                    return
                }
                
                for document in snapshotDocuments {
                    
                    let data = document.data()
                    
                    guard let userID = data["userID"] as? String else {
                        return
                    }
                    
                    guard let username = data["username"] as? String else {
                        return
                    }
                    
                    let currentIndex = self.userArray.last?.id
                    
                    let user = UserModel(id: (currentIndex ?? -1) + 1, name: username, userID: userID)
                    
                    self.userArray.append(user)
                }
                
                self.objectWillChange.send(self.userArray)
            }
        }
    }
}
