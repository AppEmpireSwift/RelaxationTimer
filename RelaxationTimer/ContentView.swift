import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingIsNeeded") var onboardingIsNeeded = true
    
    @StateObject var timerVM = TimerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
                if timerVM.timers.isEmpty {
                    placeholder()
                } else {
                    ScrollView {
                        ForEach(timerVM.timers) { timer in
                            NavigationLink(destination: DetailsView(timer: timer, deleteFunction: {timerVM.delete(timer: timer)}).navigationBarBackButtonHidden()){
                                TimerRowView(timerModel: timer)
                            }
                        }
                    }
                }
                NavigationLink {
                    AddingView(timerVM: timerVM).navigationBarBackButtonHidden()
                } label: {
                    ButtonView(text: "+")
                }
            }
            .padding()
            .fullScreenCover(isPresented: $onboardingIsNeeded) {
                OnboardingView(onboardingIsNeeded: $onboardingIsNeeded)
            }
        }
    }
}

extension ContentView {
    
    @ViewBuilder
    func placeholder() -> some View {
        VStack {
            Text("You don't have any timers created yet")
                .foregroundStyle(.accent)
                .font(.title3)
                .padding()
            Image("girl")
                .resizable()
                .scaledToFit()
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        Spacer()
    }
}
