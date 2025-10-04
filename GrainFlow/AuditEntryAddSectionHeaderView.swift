import SwiftUI

@available(iOS 14.0, *)
struct AuditEntryAddSectionHeaderView: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .foregroundColor(AETheme.brand)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 28, height: 28)
            Text(title)
                .font(.headline)
                .foregroundColor(AETheme.textPrimary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

@available(iOS 14.0, *)
struct AuditEntryAddFieldView: View {
    let label: String
    let systemImage: String
    let placeholder: String
    @Binding var text: String

    @State private var focused: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AETheme.card)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: systemImage)
                        .foregroundColor(AETheme.brand)
                        .font(.system(size: 16, weight: .semibold))
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity((focused || !text.isEmpty) ? 1 : 0.0)
                        .animation(.easeInOut(duration: 0.2))
                }
                TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                    focused = isEditing
                })
                .textContentType(.none)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.body)
                .foregroundColor(AETheme.textPrimary)
            }
            .padding(14)
        }
        .frame(minHeight: 64)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct AuditEntryAddDatePickerView: View {
    let label: String
    let systemImage: String
    @Binding var date: Date

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AETheme.card)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: systemImage)
                        .foregroundColor(AETheme.brand)
                        .font(.system(size: 16, weight: .semibold))
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
            }
            .padding(14)
        }
        .frame(minHeight: 64)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct AuditEntryChipPicker: View {
    let label: String
    let systemImage: String
    let options: [String]
    @Binding var selection: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AuditEntryAddSectionHeaderView(title: label, systemImage: systemImage)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { opt in
                        Text(opt)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selection == opt ? AETheme.brand.opacity(0.15) : AETheme.card)
                            .foregroundColor(selection == opt ? AETheme.brand : AETheme.textPrimary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selection == opt ? AETheme.brand : Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .cornerRadius(10)
                            .onTapGesture { selection = opt }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 6)
    }
}

@available(iOS 14.0, *)
struct AuditEntryDetailFieldRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(AETheme.brand)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value.isEmpty ? "—" : value)
                    .font(.body)
                    .foregroundColor(AETheme.textPrimary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
    }
}
