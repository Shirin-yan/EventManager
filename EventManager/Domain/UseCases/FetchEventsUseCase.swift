//
//  FetchEventsUseCase.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

class FetchEventsUseCase {
    private let eventRepo: EventRepo

    init(eventRepo: EventRepo) {
        self.eventRepo = eventRepo
    }

    func execute() throws -> [Event] {
        return try eventRepo.getAllEvents()
    }
}
