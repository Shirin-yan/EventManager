//
//  EventListVM.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import Foundation
import Combine

class EventListVM: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchEventsUseCase: FetchEventsUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchEventsUseCase: FetchEventsUseCase) {
        self.fetchEventsUseCase = fetchEventsUseCase
    }

    func fetchEvents() {
        isLoading = true
        errorMessage = nil

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fetchedEvents = try self.fetchEventsUseCase.execute()
                DispatchQueue.main.async {
                    self.events = fetchedEvents
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load events."
                    self.isLoading = false
                }
            }
        }
    }
}
