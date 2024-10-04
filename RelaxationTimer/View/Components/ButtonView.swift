import SwiftUI

struct ButtonView: View {
    var text = "Save"
    var width: CGFloat = .infinity
    
    var body: some View {
        Text(text)
            .font(text == "+" || text == "×" ? .title : .body)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: width, maxHeight: 50)
            .background(LinearGradient(colors: [.blurBG, .accent], startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
