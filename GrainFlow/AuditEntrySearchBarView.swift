import SwiftUI

@available(iOS 14.0, *)
struct AuditEntrySearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search audit entries", text: $text, onEditingChanged: { editing in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditing = editing
                    }
                })
                .textContentType(.none)
                .autocapitalization(.none)
                .disableAutocorrection(true)

                if isEditing && !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(10)
            .background(AETheme.card)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .scaleEffect(isEditing ? 1.02 : 1.0)

            if isEditing {
                Button("Cancel") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditing = false
                        text = ""
                        UIApplication.shared.endEditing()
                    }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@available(iOS 14.0, *)
struct AuditEntryListRowView: View {
    let entry: AuditEntry

    private var statusColor: Color {
        switch entry.approvalStatus.lowercased() {
        case "pending": return AETheme.accentOrange
        case "rejected": return Color.red
        default: return AETheme.brand
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Top line
//            HStack {
//                Label(entry.entityType, systemImage: "cube.box.fill")
//                    .font(.headline)
//                    .foregroundColor(AETheme.brand)
//                Spacer()
//                Text(entry.timestamp.aeFormatted())
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }

            // Middle summary chips
            HStack(spacing: 8) {
                chip(icon: "bolt.fill", text: entry.action, bg: AETheme.brand.opacity(0.1), fg: AETheme.brand)
                chip(icon: "exclamationmark.triangle.fill", text: entry.severity, bg: Color.yellow.opacity(0.15), fg: .orange)
                chip(icon: "checkmark.seal.fill", text: entry.approvalStatus, bg: statusColor.opacity(0.15), fg: statusColor)
            }

            // Two-column compact info
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    row(icon: "person.crop.circle", title: "By", value: entry.performedBy)
                    row(icon: "mappin.and.ellipse", title: "Location", value: entry.location)
                    row(icon: "network", title: "IP", value: entry.ipAddress)
                }
                VStack(alignment: .leading, spacing: 6) {
                    row(icon: "app.badge.fill", title: "App", value: entry.appVersion)
                    row(icon: "gearshape.2.fill", title: "OS", value: entry.osVersion)
                    row(icon: "barcode.viewfinder", title: "Ref", value: entry.referenceCode)
                }
            }

            // Tags
            if !entry.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(entry.tags, id: \.self) { t in
                            Text(t)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.08))
                                .foregroundColor(AETheme.brand)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(AETheme.card)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
        .padding(.vertical, 6)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }

    private func chip(icon: String, text: String, bg: Color, fg: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(bg)
        .foregroundColor(fg)
        .cornerRadius(10)
    }

    private func row(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            Text("\(title):")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value.isEmpty ? "—" : value)
                .font(.subheadline)
                .foregroundColor(AETheme.textPrimary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

@available(iOS 14.0, *)
struct AuditEntryNoDataView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(AETheme.brand)
            Text("No Audit Entries")
                .font(.headline)
            Text("Tap the + button to add your first entry.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 32)
    }
}
