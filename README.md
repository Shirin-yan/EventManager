# EventManager App With Media Resizer
A SwiftUI-based iOS app for creating, viewing, and managing events with local data persistence.

### This repository includes:
1. Event Management App: A SwiftUI-based application for creating and managing events with media support.
2. Video Resizer: A tool for adjusting video aspect ratios to 4:5 using AVFoundation.

### Event Management App
#### Key Features
* Event Creation: Users can input event details and upload media (images/videos).
* Event Listing: Displays events in a responsive, scrollable two-column grid.
* Event Details: Shows detailed information for each event.
* Data Persistence: Utilizes GRDB for lightweight local data storage.
Implementation Details
* Architecture: Follows Clean Architecture principles:
    * Repository Layer: Manages data operations with GRDB.
    * Use Cases: Encapsulate application logic (e.g., fetch/save events).
    * ViewModel Layer: Handles UI state and business logic.
* Media Handling: Resizes media to a 4:5 aspect ratio and stores file paths in the database for efficient memory use.
* UI: Built with SwiftUI for its declarative syntax, featuring a LazyVGrid for the event list.
Challenges and Solutions
* Database Migrations: Used GRDB’s migration API to handle schema changes.
* Media File Management: Saved large files locally in the Documents directory to prevent memory issues.
* Responsive Layout: Implemented a dynamic two-column grid with LazyVGrid.
* Dependency Injection: Ensured modularity and testability by injecting dependencies into ViewModels.

### Video Resizer
#### Key Features
* Aspect Ratio Adjustment: Resizes videos to a 4:5 aspect ratio (e.g., 1080x1350) using cropping while maintaining the original content’s proportions.
* Audio Preservation: Retains the original audio track in the output video.
* Transformation Handling: Applies the video’s preferred transform to ensure correct orientation (landscape or portrait).
Technical Approach
* Video Scaling: Dynamically scales and centers videos based on their dimensions relative to the 4:5 ratio.
* Composition: Combines video and audio tracks using AVMutableComposition and applies transformations via AVMutableVideoComposition.
* Export: Exports resized videos as .mp4 files with high-quality settings using AVAssetExportSession.
Challenges and Solutions
* Landscape Videos: Adjusted scaling dynamically to fit within the 4:5 ratio without distortion.
* Audio Sync: Ensured synchronization by aligning audio tracks with the same time range as the video.

### How to Run
1. Clone the repository.
2. Open the project in Xcode.
3. Run on a simulator or device.
