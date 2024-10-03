import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = VideoPlayerUIView()
        view.player = player
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

class VideoPlayerUIView: UIView {
    var player: AVPlayer? {
        didSet {
            (layer as? AVPlayerLayer)?.player = player
        }
    }

    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
}

