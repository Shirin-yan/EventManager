//
//  VLine.swift
//  EventManager
//
//  Created by Shirin-Yan on 22.01.2025.
//

import SwiftUI

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}
