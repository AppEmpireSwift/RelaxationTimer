import SwiftUI
import StoreKit

struct OnboardingView: View {
    @AppStorage("firstLaunch") var firstLaunch = true
    
    let pictures = ["firstPic", "secondPic"]
    let titles = ["customize your relaxation time and achieve a deep state of calm", "make your relaxation experience more pleasant and aesthetically pleasing"]
    
    @State var index = 0
    @Binding var onboardingIsNeeded: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Image(pictures[index])
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            VStack {
                Text(titles[index])
                    .font(.title)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
                    .foregroundStyle(.font)
                
                Button {
                    if index == 0{
                        index = 1
                    } else {
                        onboardingIsNeeded = false
                    }
                } label: {
                    ButtonView(text: "Continue")
                }
                HStack(spacing: 20) {
                    Button("Privacy policy") {
                        
                    }
                    Button("Terms of use") {
                        
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(.white).ignoresSafeArea())
            
        }
        .onAppear {
            if firstLaunch {
                requestAppReview()
                firstLaunch = false
            }
        }
    }
}

extension OnboardingView {
    func requestAppReview() {
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
        
    }
}
