import SwiftUI

struct ProgressView: View {
    var width: CGFloat = 160
    var height: CGFloat = 10
    var color: Color
    var totalTime: TimeInterval
    var elapsedTime: TimeInterval

    var body: some View {
        let multiplier = width / 100
        let percent = CGFloat((elapsedTime / totalTime) * 100)

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(height: height)
                .foregroundColor(Color.black.opacity(0.1))
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: min(percent, 100) * multiplier, height: height)
                .foregroundColor(color)
        }
    }
}

