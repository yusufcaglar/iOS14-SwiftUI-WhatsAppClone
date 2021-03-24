//
//  ChatModel.swift
//  WhatsAppClone
//
//  Created by Yusuf ÇAĞLAR on 25/03/2021.
//

import SwiftUI

struct ChatModel: Identifiable {
    var id: Int
    var message: String
    var messageDocID: String
    var sender: String
    var receiver: String
    var date: Double
}
