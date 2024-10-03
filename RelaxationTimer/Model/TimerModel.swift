import SwiftUI

struct TimerModel: Identifiable {
    var id: UUID
    var name: String
    var time: String
    var video: URL?
    var sound: URL?
    var image: UIImage?
    var color: Color
}
