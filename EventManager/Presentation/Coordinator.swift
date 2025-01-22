//
//  Coordinator.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import SwiftUI

enum Page: Hashable {
    case details(data: Event)
    case createEvent
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    @ViewBuilder
    func view(for page: Page) -> some View {
        switch page {
        case .details(let data):
            EventDetailView(event: data)
        case .createEvent:
            EventCreationView()
        }
    }
    
    func push(page: Page) {
        path.append(page)
    }
    
    func pop() {
        if path.count > 0 {
            path.removeLast()
        }
    }
}
