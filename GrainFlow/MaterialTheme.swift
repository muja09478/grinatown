
import SwiftUI

@available(iOS 14.0, *)
struct MaterialTheme {
    static let primary = Color(red: 0.10, green: 0.45, blue: 0.95)
    static let accent = Color(red: 0.95, green: 0.55, blue: 0.10)
    static let success = Color(red: 0.15, green: 0.75, blue: 0.45)
    static let warning = Color(red: 0.95, green: 0.35, blue: 0.25)
    static let surface = Color(white: 0.10)                         
    static let surface2 = Color(white: 0.14)
    static let subtle = Color(white: 0.22)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.85)
    
    static func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "available": return success
        case "reserved": return accent
        case "archived": return subtle
        default: return primary
        }
    }
    
    static func qualityIcon(_ quality: String) -> String {
        switch quality.lowercased() {
        case "excellent": return "star.circle.fill"
        case "good": return "checkmark.seal.fill"
        case "fair": return "exclamationmark.circle.fill"
        default: return "cube.box.fill"
        }
    }
    
    static func categoryIcon(_ category: String) -> String {
        let c = category.lowercased()
        if c.contains("wood") { return "tree.fill" }
        if c.contains("metal") { return "wrench.and.screwdriver.fill" }
        if c.contains("paint") { return "paintbrush.pointed.fill" }
        return "cube.box.fill"
    }
}
