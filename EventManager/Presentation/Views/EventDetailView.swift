//
//  EventDetailView.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct EventDetailView: View {
    @State var event: Event
    
    init(event: Event) {
        _event = State(wrappedValue: event)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let filename = event.mediaPath,
                   let url =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filename) {
                    
                    if url.pathExtension == "mp4" {
                        let player = AVPlayer(url: url)
                        VideoPlayer(player: player)
                            .scaledToFit()
                            .aspectRatio(4/5, contentMode: .fit)
                            .frame(maxHeight: 600)
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if let uiimage = UIImage(contentsOfFile: url.path) {
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(4/5, contentMode: .fit)
                            .frame(maxHeight: 600)
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                VStack {
                    Text("Title: \(event.title)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Community: \(event.community)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Description: \(event.description)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Location: \(event.location)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Start Date: \(Date(timeIntervalSince1970: event.startDate).toString())")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("End Date: \(event.endDate == 0 ? "None" : Date(timeIntervalSince1970: event.startDate).toString() )")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }.padding()
        }.navigationTitle(event.title)
    }
}

#Preview {
    EventDetailView(event: Event(id: 0, title: "1", community: "1", startDate: 100, endDate: 100, location: "", description: "1", mediaPath: ""))
}
