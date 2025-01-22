//
//  EventListView.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import SwiftUI

struct EventListView: View {
    @StateObject private var vm: EventListVM
    @EnvironmentObject var coordinator: Coordinator
    
    init() {
        let dbQueue = DatabaseManager.shared.getDBQueue()
        let useCase = FetchEventsUseCase(eventRepo: EventRepoImpl(dbQueue: dbQueue))
        _vm = StateObject(wrappedValue: EventListVM(fetchEventsUseCase: useCase))
    }
    
    let columns = [
        GridItem( .flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else if let errorMessage = vm.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(vm.events) { event in
                            EventCardView(event: event)
                                .onTapGesture {
                                    coordinator.push(page: .details(data: event))
                                }
                        }
                    }.padding()
                }
            }
        }.background(Color.gray.opacity(0.1))
        .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        coordinator.push(page: .createEvent)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }.onAppear {
                vm.fetchEvents()
            }
    }
}

#Preview {
    EventListView()
}
