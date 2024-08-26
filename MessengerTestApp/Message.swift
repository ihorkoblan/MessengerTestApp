//
//  Message.swift
//  MessengerTestApp
//
//  Created by Ihor on 23.08.2024.
//

import Foundation

struct Message: Identifiable, Hashable {
    let id: UUID
    let text: String
}
