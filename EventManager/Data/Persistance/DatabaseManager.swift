//
//  DatabaseManager.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import GRDB
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private let dbQueue: DatabaseQueue

    private init() {
        // Path to the database
        let databasePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("Events.sqlite")
            .path

        // Initialize the database queue
        dbQueue = try! DatabaseQueue(path: databasePath)

        // Migrate the database
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createTable") { db in
            try db.create(table: "eventRecord") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("community", .text).notNull()
                t.column("startDate", .date).notNull()
                t.column("endDate", .date).notNull()
                t.column("location", .text).notNull()
                t.column("description", .text).notNull()
                t.column("mediaPath", .text)
            }
        }
        
        
        try! migrator.migrate(dbQueue)
    }

    func getDBQueue() -> DatabaseQueue {
        return dbQueue
    }
}
