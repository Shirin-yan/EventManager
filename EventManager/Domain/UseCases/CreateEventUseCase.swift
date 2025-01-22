//
//  CreateEventUseCase.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

class CreateEventUseCase {
    private let eventRepo: EventRepo

    init(eventRepo: EventRepo) {
        self.eventRepo = eventRepo
    }

    func execute(event: Event) throws {
        try eventRepo.save(event: event)
    }
}

enum CreateEventError: Error {
    case invalidInput(String)
}
