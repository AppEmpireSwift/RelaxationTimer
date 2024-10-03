import SwiftUI

import SwiftUI
import AVFoundation

struct TimerRowView: View {
    var timerModel: TimerModel
    @State private var backgroundImage: UIImage?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(timerModel.name)
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                HStack {
                    Image(systemName: "clock")
                    Text(timerModel.time)
                }
                .foregroundStyle(.blurBG)
            }
            Spacer()
        }
        .padding()
        .background {
            if let uiImage = backgroundImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .clipped()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            loadBackgroundImage()
        }
    }
}

extension TimerRowView {
    private func loadBackgroundImage() {
        if let videoURL = timerModel.video {
            generateThumbnail(forUrl: videoURL) { image in
                if let image = image {
                    self.backgroundImage = image
                } else if let image = timerModel.image {
                    self.backgroundImage = image
                }
            }
        } else if let image = timerModel.image {
            backgroundImage = image
        }
    }

    private func generateThumbnail(forUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 1.0, preferredTimescale: 600)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
