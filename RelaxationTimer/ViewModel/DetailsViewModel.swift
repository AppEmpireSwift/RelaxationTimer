import Foundation
import SwiftUI
import Combine
import AVFoundation

class DetailsViewModel: ObservableObject {
    @Published var timer: TimerModel
    @Published var isStarted = false
    @Published var isPaused = false
    @Published var secondsRemaining: Int = 0
    @Published var formattedTime: String
    @Published var player: AVPlayer?
    @Published var audioPlayer: AVAudioPlayer?

    private var initialTotalSeconds: Int = 0
    private var timerCancellable: AnyCancellable?

    init(timer: TimerModel) {
        self.timer = timer
        self.formattedTime = timer.time
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
        if let videoURL = timer.video {
            self.player = AVPlayer(url: videoURL)
        } else if let soundURL = timer.sound {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                self.audioPlayer?.numberOfLoops = -1
                self.audioPlayer?.prepareToPlay()
            } catch {
                print("Error initializing audio player: \(error.localizedDescription)")
            }
        }
    }

    func start() {
        isStarted = true
        initialTotalSeconds = parseTimeString(timer.time)
        secondsRemaining = initialTotalSeconds
        isPaused = false
        formattedTime = formatTime(seconds: secondsRemaining)
        startTimer()

        if let _ = timer.video {
            player?.seek(to: .zero)
            player?.play()
        } else if let _ = timer.image, let _ = audioPlayer {
            audioPlayer?.currentTime = 0
            audioPlayer?.play()
        }
    }

    func pause() {
        isPaused = true
        stopTimer()

        if let _ = timer.video {
            player?.pause()
        } else if let _ = timer.image, let _ = audioPlayer {
            audioPlayer?.pause()
        }
    }

    func resume() {
        isPaused = false
        startTimer()

        if let _ = timer.video {
            player?.play()
        } else if let _ = timer.image, let _ = audioPlayer {
            audioPlayer?.play()
        }
    }

    func reset() {
        isStarted = false
        isPaused = false
        stopTimer()
        secondsRemaining = initialTotalSeconds
        formattedTime = timer.time

        if let _ = timer.video {
            player?.pause()
            player?.seek(to: .zero)
        } else if let _ = timer.image, let _ = audioPlayer {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
        }
    }

    private func startTimer() {
        stopTimer()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerTick()
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func timerTick() {
        if isPaused || !isStarted {
            return
        }

        if secondsRemaining > 0 {
            secondsRemaining -= 1
            formattedTime = formatTime(seconds: secondsRemaining)
        } else {
            isStarted = false
            stopTimer()

            if let _ = timer.video {
                player?.pause()
                player?.seek(to: .zero)
            } else if let _ = timer.image, let _ = audioPlayer {
                audioPlayer?.stop()
                audioPlayer?.currentTime = 0
            }
        }
    }

    func parseTimeString(_ timeString: String) -> Int {
        let components = timeString.split(separator: ":")
        if components.count == 2, let minutes = Int(components[0]), let seconds = Int(components[1]) {
            return minutes * 60 + seconds
        } else {
            return 0
        }
    }

    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var elapsedTime: TimeInterval {
        return TimeInterval(initialTotalSeconds - secondsRemaining)
    }

    var totalTime: TimeInterval {
        return TimeInterval(initialTotalSeconds)
    }
}
