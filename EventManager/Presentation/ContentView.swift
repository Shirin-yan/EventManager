//
//  ContentView.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            EventListView()
                .navigationDestination(for: Page.self) { page in
                    coordinator.view(for: page)
                }
        }.preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
