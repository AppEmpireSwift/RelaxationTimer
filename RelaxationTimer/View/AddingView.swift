import SwiftUI
import AVKit
import AVFoundation

struct AddingView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var timerVM: TimerViewModel
    
    @State private var player: AVPlayer?
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var photoPicker = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    Spacer()
                    Text("Add record")
                        .fontWeight(.medium)
                    Spacer()
                }
                
                GrayTextField(textToChange: $timerVM.newTimer.name, title: "Name of timer")
                GrayTextField(textToChange: $timerVM.newTimer.time, title: "Time", subtitle: "minutes")
                
                if timerVM.newTimer.sound != nil {
                    Button {
                        photoPicker = true
                    } label: {
                        ButtonView(text: "+ Add image")
                    }
                }
                
                if let image = timerVM.newTimer.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                if timerVM.newTimer.video == nil && timerVM.newTimer.sound == nil {
                    HStack {
                        Button {
                            timerVM.checkPhotoLibraryPermission()
                        } label: {
                            ButtonView(text: "+ Add video")
                        }
                        Button {
                            timerVM.activeSheet = .soundPicker
                        } label: {
                            ButtonView(text: "+ Add sound")
                        }
                    }
                }
                
                if let videoURL = timerVM.newTimer.video {
                    VideoPlayer(player: player)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.top, 5)
                        .onAppear {
                            player = AVPlayer(url: videoURL)
                        }
                }
                if let soundURL = timerVM.newTimer.sound {
                    HStack {
                        Image(systemName: "speaker.wave.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                        Text("\(soundURL.lastPathComponent)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(Color(UIColor.systemGray6)))
                        Button{
                            timerVM.newTimer.sound = nil
                        } label: {
                            ButtonView(text: "×", width: 50)
                        }
                    }
                }
                
                ColorsStackView(selectedColor: $timerVM.newTimer.color)
                
                Button {
                    timerVM.addNew()
                    dismiss()
                } label: {
                    ButtonView(text: "Save")
                        .opacity((timerVM.newTimer.name.isEmpty || timerVM.newTimer.time.isEmpty || timerVM.newTimer.color == .clear) && timerVM.newTimer.video == nil && timerVM.newTimer.sound == nil ? 0.5 : 1.0)
                }.disabled((timerVM.newTimer.name.isEmpty || timerVM.newTimer.time.isEmpty || timerVM.newTimer.color == .clear) && timerVM.newTimer.video == nil && timerVM.newTimer.sound == nil)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(.white).ignoresSafeArea())
            
        }
        .sheet(item: $timerVM.activeSheet) { item in
            switch item {
            case .videoPicker:
                VideoPicker(selectedVideoURL: $timerVM.newTimer.video)
            case .soundPicker:
                SoundPicker(selectedSoundURL: $timerVM.newTimer.sound)
            }
        }
        .sheet(isPresented: $photoPicker) {
            ImagePicker(image: $timerVM.newTimer.image)
        }
        .alert(isPresented: $timerVM.isAlert) {
            Alert(
                title: Text("Access to Photos is Denied"),
                message: Text("Please allow access to your photos in the Settings app."),
                primaryButton: .default(Text("Settings")) {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onDisappear {
            player?.pause()
            audioPlayer?.stop()
        }
    }
}
