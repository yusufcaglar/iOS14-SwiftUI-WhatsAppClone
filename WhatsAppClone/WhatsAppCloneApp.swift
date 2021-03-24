//
//  WhatsAppCloneApp.swift
//  WhatsAppClone
//
//  Created by Yusuf ÇAĞLAR on 22/03/2021.
//

import SwiftUI
import Firebase

@main
struct WhatsAppCloneApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView().environmentObject(UserStore())
        }
    }
}
