//
//  Event.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

struct Event: Hashable, Identifiable {
    let id: Int64?
    let title: String
    let community: String
    let startDate: Double
    let endDate: Double
    let location: String
    let description: String
    let mediaPath: String?
}
