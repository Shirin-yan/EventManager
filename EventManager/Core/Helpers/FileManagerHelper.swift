//
//  FileManagerHelper.swift
//  EventManager
//
//  Created by Shirin-Yan on 22.01.2025.
//

import Foundation

class FileManagerHelper {
    static func getDestinationUrl() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory
    }

    static func saveResizedMedia(data: Data, filename: String) -> Bool {
        let destinationUrl = getDestinationUrl().appendingPathComponent(filename)
        do {
            try data.write(to: destinationUrl)
            return true
        } catch {
            print("Failed to save file: \(error)")
            return false
        }
    }
}
