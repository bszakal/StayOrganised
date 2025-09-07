import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let isDisabled: Bool
    
    init(backgroundColor: Color, isDisabled: Bool = false) {
        self.backgroundColor = backgroundColor
        self.isDisabled = isDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .opacity(isDisabled ? 0.6 : (configuration.isPressed ? 0.8 : 1.0))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}