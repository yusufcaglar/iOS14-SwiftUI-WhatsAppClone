//
//  ContentView.swift
//  WhatsAppClone
//
//  Created by Yusuf ÇAĞLAR on 22/03/2021.
//

import SwiftUI
import Firebase

struct AuthView: View {
    
    let db = Firestore.firestore()
    //@ObservedObject var userStore = UserStore()
    @EnvironmentObject var userStore: UserStore
    
    @State var useremail: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var showAuthView = true
    
    var body: some View {
        
        NavigationView {
            if showAuthView {
                List {
                    Text("WhatsApp Clone")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.blue)
                    
                    Section {
                        TextField("Username", text: $username)
                    }
                    Section {
                        TextField("User email", text: $useremail)
                    }
                    
                    Section {
                        TextField("User password", text: $password)
                    }
                    
                    Section {
                        
                        HStack {
                            Spacer()
                            Button("Sign In") {
                                
                                Auth.auth().signIn(withEmail: useremail, password: password) { (authResult, error) in
                                    if let e = error {
                                        print("There's an error signing in! \(e.localizedDescription)")
                                    } else {
                                        self.showAuthView = false
                                    }
                                }
                                
                            }
                            Spacer()
                        }
                    }
                    
                    Section {
                        
                        HStack {
                            Spacer()
                            Button("Sign Up") {
                                Auth.auth().createUser(withEmail: useremail, password: password) { (authResult, error) in
                                    if let e = error {
                                        print("There's an error saving user! \(e.localizedDescription)")
                                    }
                                    
                                    _ = db.collection("users").addDocument(data: [
                                        "username" : username,
                                        "useremail" : useremail,
                                        "userID" : authResult!.user.uid
                                    ]) { (error) in
                                        if let e = error {
                                            print("There's an error saving user to firestore! \(e.localizedDescription)")
                                        }
                                    }
                                    
                                    // User View
                                    self.showAuthView = false
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
            else {
                // User View
                NavigationView {
                    List(userStore.userArray) { user in
                        NavigationLink(destination: ChatView(userToChat: user)) {
                            Text(user.name)
                        }
                    }
                }.navigationBarTitle(Text("Chats"))
                .navigationBarItems(trailing: Button("Log Out", action: {
                    do {
                       try  Auth.auth().signOut()
                        self.showAuthView = true
                    } catch {
                        
                    }
                   
                }))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthView(showAuthView: false)
            AuthView()
        }
    }
}
