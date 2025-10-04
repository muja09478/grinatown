import SwiftUI


@available(iOS 14.0, *)
struct EstimateTheme {
    static let bg = Color(.systemBackground)
    static let card = Color(.secondarySystemBackground)
    static let primary = Color(.systemTeal)
    static let accent = Color(.systemOrange)
    static let success = Color(.systemGreen)
    static let warning = Color(.systemYellow)
    static let danger = Color(.systemRed)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let chip = Color(.systemBlue)
}

@available(iOS 14.0, *)
struct EstimateAddSectionHeaderView: View {
    let systemIcon: String
    let title: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemIcon)
                .foregroundColor(EstimateTheme.primary)
                .frame(width: 28, height: 28)
                .background(EstimateTheme.primary.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(title)
                .font(.headline)
                .foregroundColor(EstimateTheme.textPrimary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

@available(iOS 14.0, *)
struct EstimateAddFieldView: View {
    let icon: String
    let label: String
    var keyboard: UIKeyboardType = .default
    @Binding var text: String
    @State private var isEditing: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(EstimateTheme.accent)
                    .padding(8)
                    .background(EstimateTheme.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(isEditing || !text.isEmpty ? EstimateTheme.accent : EstimateTheme.textSecondary)

                    TextField("", text: $text, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .keyboardType(keyboard)
                    .foregroundColor(EstimateTheme.textPrimary)
                    .accessibilityLabel(Text(label))
                }
            }
            Divider().background(EstimateTheme.accent.opacity(isEditing ? 0.7 : 0.2))
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(EstimateTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct EstimateAddDatePickerView: View {
    let icon: String
    let title: String
    @Binding var date: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            EstimateAddSectionHeaderView(systemIcon: icon, title: title)
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(EstimateTheme.primary)
                    .padding(8)
                    .background(EstimateTheme.primary.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .labelsHidden()
                    .accentColor(EstimateTheme.primary)
                    .accessibilityLabel(Text(title))
                Spacer()
            }
            .padding()
            .background(EstimateTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
    }
}

@available(iOS 14.0, *)
struct EstimateCardRow<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            EstimateAddSectionHeaderView(systemIcon: icon, title: title)
            HStack {
                content
            }
            .padding()
            .background(EstimateTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
    }
}

@available(iOS 14.0, *)
struct EstimateSearchBarView: View {
    @Binding var text: String
    @State private var isActive = false

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(EstimateTheme.textSecondary)
                TextField("Search estimates", text: $text, onEditingChanged: { editing in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isActive = editing || !text.isEmpty
                    }
                })
                .foregroundColor(EstimateTheme.textPrimary)
                if !text.isEmpty {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            text = ""
                            isActive = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(EstimateTheme.textSecondary)
                    }
                    .accessibilityLabel(Text("Clear search"))
                }
            }
            .padding(10)
            .background(EstimateTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(isActive ? 0.08 : 0.03), radius: isActive ? 12 : 6, x: 0, y: isActive ? 6 : 2)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

@available(iOS 14.0, *)
struct EstimateListRowView: View {
    let estimate: Estimate
    let clientName: String
    let jobCode: String

    private var statusColor: Color {
        switch estimate.status.lowercased() {
        case "approved": return EstimateTheme.success
        case "draft": return EstimateTheme.warning
        case "rejected": return EstimateTheme.danger
        default: return EstimateTheme.chip
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(estimate.referenceCode)
                        .font(.title3).bold()
                        .foregroundColor(EstimateTheme.textPrimary)

                    Text(clientName)
                        .font(.subheadline)
                        .foregroundColor(EstimateTheme.textSecondary)

                    Text("Job: \(jobCode)")
                        .font(.caption)
                        .foregroundColor(EstimateTheme.accent)
                }
                Spacer()
                Text(estimate.status.uppercased())
                    .font(.caption).bold()
                    .foregroundColor(statusColor)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(statusColor.opacity(0.15))
                    .clipShape(Capsule())
            }

            Divider()

            // MARK: - Highlight Row
            HStack(spacing: 12) {
                highlightCard(icon: "dollarsign.circle", label: "Grand Total",
                              value: Self.currency(estimate.grandTotal, estimate.currency),
                              color: EstimateTheme.primary)

                highlightCard(icon: "percent", label: "Tax",
                              value: "\(estimate.taxAmount)",
                              color: EstimateTheme.accent)

                highlightCard(icon: "scissors", label: "Discount",
                              value: "\(estimate.discount)",
                              color: EstimateTheme.warning)
            }

            // MARK: - Grid Details
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                EstimateKVRow(icon: "calendar", label: "Issued", value: Self.dateString(estimate.issueDate))
                EstimateKVRow(icon: "calendar.badge.exclamationmark", label: "Valid Until", value: Self.dateString(estimate.validUntil))
                EstimateKVRow(icon: "number.square", label: "Version", value: "\(estimate.version)")
                EstimateKVRow(icon: "signature", label: "Prepared By", value: estimate.preparedBy)
                EstimateKVRow(icon: "checkmark.seal", label: "Approval", value: estimate.approvalStatus)
                EstimateKVRow(icon: "banknote", label: "Payment Terms", value: estimate.paymentTerms)
                EstimateKVRow(icon: "shippingbox", label: "Delivery", value: estimate.deliverySchedule)
                EstimateKVRow(icon: "lock.doc", label: "Legal", value: estimate.legalClauses.isEmpty ? "—" : "Included")
                EstimateKVRow(icon: "shield.checkerboard", label: "Warranty", value: estimate.warrantyTerms)
            }

            // MARK: - Tags
            if !estimate.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(estimate.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption).bold()
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(EstimateTheme.accent.opacity(0.15))
                                .foregroundColor(EstimateTheme.accent)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }

        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
        .padding(.vertical, 8)
        .accessibilityElement(children: .contain)
    }

    // MARK: - Helper Views
    private func highlightCard(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20, weight: .bold))
            Text(value)
                .font(.headline).bold()
                .foregroundColor(EstimateTheme.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    static func dateString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: date)
    }

    static func currency(_ value: Double, _ code: String) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencyCode = code
        return nf.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

@available(iOS 14.0, *)
struct EstimateKVRow: View {
    let icon: String
    let label: String
    let value: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(EstimateTheme.accent)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(EstimateTheme.textPrimary)
            }
            
            Spacer()
        }
        .background(EstimateTheme.card.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}



@available(iOS 14.0, *)
struct EstimateDetailFieldRow: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(EstimateTheme.primary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.footnote).bold()
                    .foregroundColor(EstimateTheme.textPrimary)
                Text(value.isEmpty ? "—" : value)
                    .font(.subheadline)
                    .foregroundColor(EstimateTheme.textSecondary)
            }
            Spacer()
        }
        .padding(10)
        .background(EstimateTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(title) \(value)"))
    }
}

@available(iOS 14.0, *)
struct EstimateNoDataView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundColor(EstimateTheme.textSecondary)
                .padding(16)
                .background(EstimateTheme.card)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            Text("No Estimates")
                .font(.headline)
                .foregroundColor(EstimateTheme.textPrimary)
            Text("Tap the + button to add a new estimate.")
                .font(.subheadline)
                .foregroundColor(EstimateTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 40)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("No estimates. Add a new estimate."))
    }
}
