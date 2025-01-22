//
//  ThumbanilGenerator.swift
//  EventManager
//
//  Created by Shirin-Yan on 22.01.2025.
//

import AVFoundation
import UIKit

class ThumbanilGenerator {
    
    static let shared = ThumbanilGenerator()
    
    private init() { }
    
    func getThumbnail(for filename: String) -> UIImage? {
        guard let url =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filename) else { return nil }

        if url.pathExtension == "mp4" {
            return generateThumbnail(for: filename)
        } else {
            return UIImage(contentsOfFile: url.path)
        }
    }
    func generateThumbnail(for filename: String) -> UIImage? {
        guard let url =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filename) else { return nil }
        
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        do {
            let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}
