//
//  Task.swift
//  TaskManager
//
//  Created by Mahi on 30/3/26.
//

import SwiftData
import Foundation

@Model
class Task {

    // @Attribute(.unique) ensures no two tasks share the same id
    @Attribute(.unique) var id: UUID

    var title: String
    var notes: String
    var isComplete: Bool
    var createdAt: Date

    init(title: String, notes: String = "") {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.isComplete = false
        self.createdAt = Date()
    }
}
