import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL
    var isPlaying: Binding<Bool>? = nil   // opsional: jika tidak dikirim, video autoplay
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        player.isMuted = true
        context.coordinator.player = player
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.videoGravity = .resizeAspectFill
        
        // Loop video otomatis
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        // Jalankan sesuai mode
        if let binding = isPlaying {
            if binding.wrappedValue {
                player.play()
            } else {
                player.pause()
            }
        } else {
            player.play()
        }
        
        return controller
    }
    
    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        guard let player = context.coordinator.player else { return }
        
        // Kontrol player dari binding setiap kali state berubah
        if let binding = isPlaying {
            if binding.wrappedValue && player.timeControlStatus != .playing {
                player.play()
            } else if !binding.wrappedValue && player.timeControlStatus == .playing {
                player.pause()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: VideoPlayerView
        var player: AVPlayer?
        
        init(_ parent: VideoPlayerView) {
            self.parent = parent
        }
        
        @objc func playerDidFinishPlaying(_ note: Notification) {
            // Loop video setelah selesai
            player?.seek(to: .zero)
            player?.play()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
