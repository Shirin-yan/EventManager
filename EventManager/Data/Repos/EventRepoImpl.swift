//
//  EventRepoImpl.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import Foundation
import GRDB

class EventRepoImpl: EventRepo {
    private let dbQueue: DatabaseQueue

    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }

    func save(event: Event) throws {
        let eventRecord = EventRecord(event: event)
        try dbQueue.write { db in
            try eventRecord.insert(db)
        }
    }

    func getAllEvents() throws -> [Event] {
        try dbQueue.read { db in
            let eventRecords = try EventRecord.fetchAll(db).reversed()
            return eventRecords.map { $0.toDomain() }
        }
    }

    func deleteEvent(by id: Int64) throws {
        let _ = try dbQueue.write { db in
            try EventRecord.deleteOne(db, key: id)
        }
    }
}
