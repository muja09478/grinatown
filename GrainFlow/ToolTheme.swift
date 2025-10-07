

import SwiftUI

@available(iOS 14.0, *)
enum ToolTheme {
   
    static let brandBlue = Color(#colorLiteral(red: 0.078, green: 0.345, blue: 0.749, alpha: 1))
    static let accentTeal = Color(#colorLiteral(red: 0.062, green: 0.694, blue: 0.596, alpha: 1))
    static let accentOrange = Color(#colorLiteral(red: 0.980, green: 0.576, blue: 0.145, alpha: 1))
    static let cardBg = Color(#colorLiteral(red: 0.965, green: 0.973, blue: 0.988, alpha: 1))        
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let chipBg = Color(#colorLiteral(red: 0.902, green: 0.941, blue: 0.996, alpha: 1))
}

@available(iOS 14.0, *)
extension View {
    func toolCardStyle() -> some View {
        self
            .background(ToolTheme.cardBg)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ToolTheme.brandBlue.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

@available(iOS 14.0, *)
struct Pill: View {
    let title: String
    let color: Color
    var body: some View {
        Text(title)
            .font(.footnote).bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
            .accessibility(label: Text(title))
    }
}
