import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Timers")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.font)
            Spacer()
            NavigationLink {
                SettingsView().navigationBarBackButtonHidden()
            } label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
        }
    }
}
