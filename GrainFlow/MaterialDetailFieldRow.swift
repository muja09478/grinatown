
import SwiftUI

@available(iOS 14.0, *)
struct MaterialDetailFieldRow: View {
    let icon: String
    let title: String
    let value: String
    var accent: Color = MaterialTheme.primary
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(accent)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(MaterialTheme.textSecondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(MaterialTheme.textPrimary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
