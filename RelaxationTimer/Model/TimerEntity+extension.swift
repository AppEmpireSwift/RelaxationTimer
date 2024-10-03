import SwiftUI

extension TimerEntity {
    func toTimerModel() -> TimerModel {
        return TimerModel(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            time: self.time ?? "",
            video: URL(fileURLWithPath: self.video ?? ""),
            sound: URL(fileURLWithPath: self.sound ?? ""),
            image: UIImage(data: self.photo ?? Data()),
            color: Color(hex: self.color ?? "") ?? .clear)
    }
    
    func update(from timerModel: TimerModel) {
        self.id = timerModel.id
        self.name = timerModel.name
        self.color = timerModel.color.toHex()
        self.time = timerModel.time
        self.video = timerModel.video?.path
        self.sound = timerModel.sound?.path
        self.photo = timerModel.image?.jpegData(compressionQuality: 1.0)
    }
}
