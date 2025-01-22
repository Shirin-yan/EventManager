//
//  EventRecord.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import GRDB

struct EventRecord: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var title: String
    let community: String
    let startDate: Double
    let endDate: Double
    var location: String
    var description: String
    var mediaPath: String?

    // Converts Domain Event to EventRecord
    init(event: Event) {
        self.id = event.id
        self.title = event.title
        self.community = event.community
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.location = event.location
        self.description = event.description
        self.mediaPath = event.mediaPath
    }

    // Converts EventRecord to Domain Event
    func toDomain() -> Event {
        return Event(
            id: id,
            title: title,
            community: community,
            startDate: startDate,
            endDate: endDate,
            location: location,
            description: description,
            mediaPath: mediaPath
        )
    }
}
