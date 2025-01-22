//
//  EventCreationVM.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import Foundation
import UIKit
import Combine

class EventCreationVM: ObservableObject {
    @Published var title: String = ""
    @Published var community: String = ""
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var location: String = ""
    @Published var description: String = ""
    @Published var selectedMedia: UIImage?
    @Published var selectedFilename = ""
    
    @Published var isAlertPresented = false
    @Published var alertMessage = ""

    
    var errorMessage: String? {
        didSet {
            alertMessage = errorMessage ?? ""
            isAlertPresented = errorMessage != nil
        }
    }

    private let createEventUseCase: CreateEventUseCase
    private var cancellables = Set<AnyCancellable>()

    init(createEventUseCase: CreateEventUseCase) {
        self.createEventUseCase = createEventUseCase
    }

    func saveEvent() -> Bool {
        guard !title.isEmpty else {
            errorMessage = "Title is required."
            return false
        }
        
        guard !description.isEmpty else {
            errorMessage = "Description is required."
            return false
        }
        
        guard let startDate else {
            errorMessage = "Start date is required."
            return false
        }
        
        let event = Event(
            id: nil,
            title: title,
            community: community,
            startDate: startDate.timeIntervalSince1970,
            endDate: endDate?.timeIntervalSince1970 ?? 0,
            location: location,
            description: description,
            mediaPath: selectedFilename
        )

        do {
            try createEventUseCase.execute(event: event)
            return true
        } catch {
            debugPrint(error)
            errorMessage = "Failed to save event. Please try again."
            return false
        }
    }
}

