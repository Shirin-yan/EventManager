//
//  EventRepo.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

protocol EventRepo {
    func save(event: Event) throws
    func getAllEvents() throws -> [Event]
    func deleteEvent(by id: Int64) throws
}
