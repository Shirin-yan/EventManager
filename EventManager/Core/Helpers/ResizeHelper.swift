//
//  ResizeHelper.swift
//  EventManager
//
//  Created by Shirin-Yan on 22.01.2025.
//

import AVFoundation
import UIKit

class ResizeHelper {
    static func resizeImg(data: Data, toAspectRatio: CGFloat) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let originalSize = image.size
        let newHeight = originalSize.width / toAspectRatio
        let newSize = CGSize(width: originalSize.width, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage?.jpegData(compressionQuality: 1.0)
    }

    static func resizeVideo(data: Data, toAspectRatio: CGFloat) async -> Data? {
        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
        try? data.write(to: tempUrl)
        
        let asset = AVURLAsset(url: tempUrl)
        let task: Task<Data?, Error> =  Task {
            do {
                let duration = try await asset.load(.duration)
                let composition = AVMutableComposition()
                
                guard let videoTrack = try await asset.loadTracks(withMediaType: .video).first else {
                    throw NSError(domain: "com.example.video", code: -1, userInfo: [NSLocalizedDescriptionKey: "No video track found"])
                }
                
                let videoCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
                do {
                    try videoCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: duration),
                                                               of: videoTrack,
                                                               at: .zero)
                } catch {
                    throw error
                }
                
                guard let audioTrack = try await asset.loadTracks(withMediaType: .audio).first else {
                    throw NSError(domain: "com.example.video", code: -1, userInfo: [NSLocalizedDescriptionKey: "No audio track found"])
                }
                
                let audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                do {
                    try audioCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: duration),
                                                               of: audioTrack,
                                                               at: .zero)
                } catch {
                    throw error
                }
                
                // Set up video composition
                let videoComposition = AVMutableVideoComposition()
                videoComposition.renderSize = CGSize(width: 1080, height: 1350) // 4:5 aspect ratio
                videoComposition.frameDuration = CMTime(value: 1, timescale: 30) // 30 FPS

                let instruction = AVMutableVideoCompositionInstruction()
                instruction.timeRange = CMTimeRange(start: .zero, duration: duration)

                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoCompositionTrack!)
                
                // Calculate scaling
                let videoSize = try await videoTrack.load(.naturalSize)
                let transform = try await videoTrack.load(.preferredTransform)
                let transformedVideoSize = videoSize.applying(transform)
                let absWidth = abs(transformedVideoSize.width)
                let absHeight = abs(transformedVideoSize.height)
                
                let scale: CGFloat
                if absWidth / absHeight > 4.0 / 5.0 {
                    // Wider than 4:5, scale by height
                    scale = 1350.0 / absHeight
                } else {
                    // Taller than 4:5, scale by width
                    scale = 1080.0 / absWidth
                }
                
                let tx = (1080.0 - absWidth * scale) / 2.0
                let ty = (1350.0 - absHeight * scale) / 2.0
                let finalTransform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale)).concatenating(CGAffineTransform(translationX: tx, y: ty))
                layerInstruction.setTransform(finalTransform, at: .zero)
                
                instruction.layerInstructions = [layerInstruction]
                videoComposition.instructions = [instruction]

                let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
                    .appendingPathComponent("\(UUID().uuidString).mp4")
                
                guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
                    throw NSError(domain: "com.example.video", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot create export session"])
                }
                
                exportSession.outputURL = exportURL
                exportSession.outputFileType = .mp4
                exportSession.videoComposition = videoComposition

                var isExported = false
                exportSession.exportAsynchronously {
                    DispatchQueue.main.async {
                        switch exportSession.status {
                        case .completed:
                            isExported = true
                            break
                        default:
                            isExported = true
                            if let error = exportSession.error {
                                debugPrint(error)
                            }
                            break
                        }
                    }
                }
                
                while !isExported {}
                return try Data(contentsOf: exportURL)
            } catch {
                debugPrint(error)
                return nil
            }
        }
        
        do {
            return try await task.value
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
