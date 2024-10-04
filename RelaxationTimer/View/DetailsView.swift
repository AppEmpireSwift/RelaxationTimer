import SwiftUI

struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var detailsVM: DetailsViewModel
    
    var deleteFunction: () -> Void
    
    init(timer: TimerModel, deleteFunction: @escaping () -> Void) {
        _detailsVM = StateObject(wrappedValue: DetailsViewModel(timer: timer))
        self.deleteFunction = deleteFunction
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                VStack {
                    if let image = detailsVM.timer.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height / 1.3)
                            .ignoresSafeArea()
                    } else if detailsVM.player != nil {
                        VideoPlayerView(player: detailsVM.player!)
                            .frame(width: geo.size.width, height: geo.size.height / 1.3)
                            .ignoresSafeArea()
                    } else {
                        Image("background")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height / 1.3)
                            .ignoresSafeArea()
                    }
                    Spacer()
                }
                VStack(spacing: 30) {
                    header()
                    Button(action: {
                        if !detailsVM.isStarted {
                            detailsVM.start()
                        } else if detailsVM.isPaused {
                            detailsVM.resume()
                        } else {
                            detailsVM.pause()
                        }
                    }) {
                        Image(systemName: !detailsVM.isStarted ? "play"  : "pause")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(detailsVM.timer.color)
                    }
                    Text(detailsVM.formattedTime)
                        .font(.system(size: 45))
                        .fontWeight(.heavy)
                    Text(detailsVM.timer.name)
                    ProgressView(
                        color: detailsVM.timer.color,
                        totalTime: detailsVM.totalTime,
                        elapsedTime: detailsVM.elapsedTime
                    )
                    ColorsStackView(selectedColor: $detailsVM.timer.color, enableToChange: false)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.white)
                        .ignoresSafeArea()
                )
            }
            .foregroundStyle(detailsVM.timer.color)
        }
    }
}

extension DetailsView {
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Timers")
                }
            }
            Spacer()
            Button {
                deleteFunction()
            } label: {
                Image(systemName: "trash")
                
            }
        }
    }
}
