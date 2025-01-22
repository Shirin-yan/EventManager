//
//  EventCardView.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import SwiftUI

struct EventCardView: View {
    let event: Event

    var body: some View {
        VStack {
            if let filename = event.mediaPath,
               let image = ThumbanilGenerator.shared.getThumbnail(for: filename) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(4/5, contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
            } else {
                Color.black.opacity(0.2)
                    .aspectRatio(4/5, contentMode: .fit)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            VStack {
                if !event.community.isEmpty {
                    Text(event.community)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                }
                
                if !event.title.isEmpty {
                    Text(event.title)
                        .lineLimit(1)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(Date(timeIntervalSince1970: event.startDate).toString())
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }.padding(8)
                .frame(minHeight: 70)
        }.background(Color.white)
            .cornerRadius(10)
    }
}
