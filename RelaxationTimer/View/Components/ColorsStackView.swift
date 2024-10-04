import SwiftUI

struct ColorsStackView: View {
    let colors: [Color] = [.accent, .greenStyle, .cyanStyle, .purpleStyle]
    
    @Binding var selectedColor: Color
    
    @State var enableToChange = true
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxHeight: 42)
                    .foregroundStyle(color)
                    .onTapGesture {
                        if enableToChange {
                            selectedColor = color
                        }
                    }
                    .opacity(selectedColor.toHex() == color.toHex() ? 1.0 : 0.3)
            }
        }
    }
}
