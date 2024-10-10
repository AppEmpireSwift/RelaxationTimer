import SwiftUI

struct GrayTextField: View {
    @Binding var textToChange: String
    var title: String
    var subtitle: String?
    @State private var isSubmitted = false
    @State private var isError = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(title, text: $textToChange)
                    .onSubmit {
                        validateInput()
                    }
                    .onChange(of: textToChange) { newValue in
                        if title == "Time (eg 15:00)" {
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
            .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(LinearGradient(colors: isSubmitted ? (isError ? [.red, .red] : [.blurBG, .accent]) : [.clear],
                                startPoint: .leading, endPoint: .trailing), lineWidth: 2))
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    private func validateInput() {
        isSubmitted = true
        if title == "Time" && !isTimeFormatValid(textToChange) {
            isError = true
            errorMessage = "Time should be in MM:SS format"
        } else {
            isError = false
            errorMessage = nil
        }
    }

    private func isTimeFormatValid(_ input: String) -> Bool {
        let timeRegex = "^\\d{2}:\\d{2}$"
        return input.range(of: timeRegex, options: .regularExpression) != nil
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

