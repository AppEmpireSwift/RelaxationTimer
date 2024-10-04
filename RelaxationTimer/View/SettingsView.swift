import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settingsVM = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    VStack(spacing: 30) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Timers")
                            }.foregroundStyle(.font)
                        }
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.font)
                    }
                    Spacer()
                }
                ScrollView {
                    Button(action: {
                        settingsVM.sendEmail()
                    }) {
                        SettingsRow(iconName: "statement", title: "Statement")
                    }
                    
                    Button(action: {
                        settingsVM.rateApp()
                    }) {
                        SettingsRow(iconName: "rate", title: "Rate this App")
                    }
                    
                    Button(action: {
                        settingsVM.shareApp()
                    }) {
                        SettingsRow(iconName: "share", title: "Share")
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        SettingsRow(iconName: "about", title: "About Us")
                    }
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        SettingsRow(iconName: "privacy", title: "Privacy Policy")
                    }
                    
                    NavigationLink(destination: TermsOfUseView()) {
                        SettingsRow(iconName: "terms", title: "Terms of Use")
                    }
                }
            }
            .padding()
        }
    }
}

struct SettingsRow: View {
    let iconName: String
    let title: String
    
    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .foregroundColor(.accentColor)
            Text(title)
                .foregroundStyle(.font)
                .font(.system(size: 18))
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About This App")
                .font(.largeTitle)
                .padding()
            Text("App Name: RelaxationTimer")
                .font(.title2)
            Spacer()
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        VStack {
            Text("Privacy Policy")
                .font(.largeTitle)
                .padding()
            Text("Your privacy policy text here.")
                .font(.body)
            Spacer()
        }
    }
}

struct TermsOfUseView: View {
    var body: some View {
        VStack {
            Text("Terms of Use")
                .font(.largeTitle)
                .padding()
            Text("Your terms of use text here.")
                .font(.body)
            Spacer()
        }
    }
}
