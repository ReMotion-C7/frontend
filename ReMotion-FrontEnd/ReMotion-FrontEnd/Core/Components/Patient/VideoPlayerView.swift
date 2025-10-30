//
//  SwiftUIView.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 30/10/25.
//

import SwiftUI
import AVKit

// This struct is a wrapper around the UIKit AVPlayerViewController to make it usable in SwiftUI.
struct VideoPlayerView: UIViewControllerRepresentable {
    
    let videoURL: URL
    
    // This function creates the underlying UIKit view controller.
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        
        // --- FIX: Pass the created player to the coordinator ---
        context.coordinator.player = player
        
        // Add an observer to detect when the video finishes playing
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        player.play()
        
        return controller
    }
    
    // This function is called whenever the SwiftUI view's state changes (e.g., videoURL changes).
    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        // Get the URL of the video that's currently loaded in the player.
        let currentURL = (controller.player?.currentItem?.asset as? AVURLAsset)?.url
        
        // Compare the current URL with the new URL from the parent view.
        // If they are different, we need to update the video.
        if currentURL != videoURL {
            
            // 1. Create a new player with the new URL.
            let newPlayer = AVPlayer(url: videoURL)
            
            // 2. Assign the new player to the controller.
            controller.player = newPlayer
            
            // 3. Update the coordinator's reference to the new player.
            context.coordinator.player = newPlayer
            
            // 4. IMPORTANT: Remove the old observer before adding a new one to prevent memory leaks.
            NotificationCenter.default.removeObserver(
                context.coordinator,
                name: .AVPlayerItemDidPlayToEndTime,
                object: nil // Removing for all objects is safest here
            )
            
            // 5. Add the looping observer to the new player's video item.
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: newPlayer.currentItem
            )
            
            // 6. Play the new video.
            newPlayer.play()
        }
    }
    
    // The Coordinator is a bridge for handling events between UIKit and SwiftUI.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: VideoPlayerView
        // --- FIX: Add a variable to hold the actual player ---
        var player: AVPlayer?
        
        init(_ parent: VideoPlayerView) {
            self.parent = parent
        }
        
        // This function is now called on the correct player
        @objc func playerDidFinishPlaying(note: NSNotification) {
            // Seek back to the beginning and play again to create an endless loop
            player?.seek(to: .zero)
            player?.play()
        }
    }
}

// Add a convenience accessor to get the player
extension VideoPlayerView {
    var player: AVPlayer {
        return AVPlayer(url: videoURL)
    }
}
