import SwiftUI

struct GrayTextField: View {
    @Binding var textToChange: String
    var title: String
    var subtitle: String?
    @State var isSubmitted = false
    
    var body: some View {
        HStack {
            TextField(title, text: $textToChange)
                .onSubmit {
                    isSubmitted = true
                }
                .onChange(of: textToChange) { newValue in
                    if title == "Time" {
                        textToChange = formatTimeInput(newValue)
                    }
                }
            if let subtitle {
                Text(subtitle)
            }
        }
        .padding()
        .frame(maxHeight: 50)
        .background(Color(UIColor.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(LinearGradient(colors: isSubmitted ? [.blurBG, .accent] : [.clear], startPoint: .leading, endPoint: .trailing), lineWidth: 2))
    }
}

extension GrayTextField {
    
    private func formatTimeInput(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        var result = ""
        let maxLength = 4
        let limitedDigits = String(digits.prefix(maxLength))
        for (index, char) in limitedDigits.enumerated() {
            if index == 2 {
                result.append(":")
            }
            result.append(char)
        }
        return result
    }
}
