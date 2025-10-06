import SwiftUI

private extension Color {
    static let jlBlue = Color(.sRGB, red: 0.10, green: 0.45, blue: 0.95, opacity: 1)
    static let jlGreen = Color(.sRGB, red: 0.12, green: 0.70, blue: 0.40, opacity: 1)
    static let jlOrange = Color(.sRGB, red: 0.98, green: 0.60, blue: 0.12, opacity: 1)
    static let jlInk = Color(.sRGB, red: 0.08, green: 0.10, blue: 0.14, opacity: 1)
    static let jlCard = Color(.sRGB, red: 0.98, green: 0.99, blue: 1.00, opacity: 1)
}

@available(iOS 14.0, *)
struct JobListingAddSectionHeaderView: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.jlBlue, .jlGreen]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                )
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, 8)
        .accessibilityElement(children: .combine)
    }
}

@available(iOS 14.0, *)
struct JobListingAddFieldView: View {
    let icon: String
    let label: String
    var keyboard: UIKeyboardType = .default
    @Binding var text: String

    @State private var isFocused: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.jlCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(isFocused ? Color.jlBlue : Color.gray.opacity(0.2), lineWidth: 1)
                )

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.jlBlue)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 20)
                    .accessibilityHidden(true)

                ZStack(alignment: .leading) {
                    Text(label)
                        .foregroundColor(.secondary)
                        .opacity((text.isEmpty && !isFocused) ? 1 : 0)
                    TextField("", text: $text, onEditingChanged: { editing in
                        withAnimation(.easeInOut(duration: 0.2)) { isFocused = editing }
                    })
                    .keyboardType(keyboard)
                    .textContentType(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .accessibilityLabel(Text(label))
    }
}

@available(iOS 14.0, *)
struct JobListingAddDatePickerView: View {
    let icon: String
    let label: String
    @Binding var date: Date?

    @State private var isExpanded: Bool = false
    @State private var internalDate: Date = Date()

    var body: some View {
        VStack(spacing: 8) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.jlGreen)
                        .frame(width: 20)
                        .accessibilityHidden(true)
                    Text(date != nil ? dateFormatted(date!) : label)
                        .foregroundColor(date == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.jlCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .accessibilityLabel(Text(label))

            if isExpanded {
                DatePicker("", selection: $internalDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .onChange(of: internalDate) { value in
                        date = value
                    }
                    .onAppear {
                        internalDate = date ?? Date()
                    }
            }
        }
    }

    private func dateFormatted(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: d)
    }
}

@available(iOS 14.0, *)
struct JobListingDetailFieldRow: View {
    let icon: String
    let title: String
    let value: String
    var color: Color = .jlInk

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 18)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundColor(.secondary)
                Text(value).font(.subheadline).foregroundColor(.primary).lineLimit(2)
            }
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
struct JobListingChipsView: View {
    let items: [String]
    var color: Color = .jlBlue

    var body: some View {
        FlexibleChips(items: items, color: color)
    }
}

@available(iOS 14.0, *)
struct FlexibleChips: View {
    let items: [String]
    var color: Color

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geo in
            self.generateContent(in: geo)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                chip(for: item)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == items.last! {
                            width = 0 // last
                        } else {
                            width -= d.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if item == items.last! {
                            height = 0 // last
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func chip(for text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundColor(.white)
            .background(color.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.trailing, 6)
            .padding(.bottom, 6)
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: HeightPreferenceKey.self, value: geo.size.height)
        }
        .onPreferenceChange(HeightPreferenceKey.self) { binding.wrappedValue = $0 }
    }

    private struct HeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
    }
}

@available(iOS 14.0, *)
struct JobListingSearchBarView: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    @State private var glow: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(8)
                .background(Circle().fill(Color.jlBlue ))

            TextField("Search jobs, status, location, tags...", text: $text, onEditingChanged: { editing in
                withAnimation(.easeInOut) { isEditing = editing }
            })
            .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(.primary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.jlCard)
                .shadow(color: Color.black.opacity(isEditing ? 0.08 : 0.03), radius: isEditing ? 8 : 4, x: 0, y: 2)
        )
        .accessibilityLabel(Text("Search jobs"))
    }
}

@available(iOS 14.0, *)
struct JobListingListRowView: View {
    let job: JobListing
    let clientName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .center) {
                Image(systemName: "hammer.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [.jlBlue,.jlGreen]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(job.title).font(.headline).foregroundColor(.primary)
                    Text(clientName).font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                StatusBadge(text: job.status)
            }

            // Quick meta
            HStack(spacing: 12) {
                Meta(icon: "mappin.and.ellipse", text: job.location)
                Meta(icon: "clock", text: "\(job.progress)%")
                Meta(icon: "tag.fill", text: job.category)
            }

            // Grid of fields (rich data)
            let grid = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
            LazyVGrid(columns: grid, spacing: 10) {
                JobListingDetailFieldRow(icon: "number", title: "Ref", value: job.referenceCode)
                JobListingDetailFieldRow(icon: "calendar", title: "Start", value: dateText(job.startDate))
                JobListingDetailFieldRow(icon: "calendar.badge.clock", title: "End", value: dateText(job.endDate))
                JobListingDetailFieldRow(icon: "dollarsign.circle", title: "Budget", value: money(job.budget, job.currency), color: .jlGreen)
                JobListingDetailFieldRow(icon: "tray.full.fill", title: "Priority", value: job.priority)
                JobListingDetailFieldRow(icon: "person.3.fill", title: "Team", value: job.assignedCarpenters.joined(separator: ", "))
                JobListingDetailFieldRow(icon: "hourglass", title: "Est Hrs", value: "\(job.estimatedHours)")
                JobListingDetailFieldRow(icon: "clock.fill", title: "Actual Hrs", value: "\(job.actualHours)")
                JobListingDetailFieldRow(icon: "creditcard.fill", title: "Payment", value: job.paymentStatus)
                JobListingDetailFieldRow(icon: "doc.text.fill", title: "Invoice", value: job.invoiceNumber)
                JobListingDetailFieldRow(icon: "checkmark.seal.fill", title: "Quality", value: job.qualityCheckStatus, color: .jlGreen)
                JobListingDetailFieldRow(icon: "person.badge.shield.checkmark", title: "Approval", value: job.approvalStatus)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.jlCard)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
        )
        .accessibilityElement(children: .contain)
    }

    private func dateText(_ d: Date?) -> String { d.map { df.string(from: $0) } ?? "—" }
    private var df: DateFormatter { let f = DateFormatter(); f.dateStyle = .medium; return f }
    private func money(_ v: Double, _ c: String) -> String { "\(c) \(String(format: "%.2f", v))" }

    private struct Meta: View {
        let icon: String; let text: String
        var body: some View {
            HStack(spacing: 6) {
                Image(systemName: icon).foregroundColor(.jlBlue)
                Text(text).foregroundColor(.secondary).font(.caption)
            }
        }
    }

    private struct StatusBadge: View {
        let text: String
        var body: some View {
            Text(text)
                .font(.caption).bold()
                .padding(.vertical, 4).padding(.horizontal, 8)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(text.lowercased() == "ongoing" ? Color.jlBlue : (text.lowercased() == "approved" ? Color.jlGreen : Color.jlOrange))
                )
        }
    }
}

@available(iOS 14.0, *)
struct JobListingNoDataView: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "hammer.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(.jlBlue)
            Text("No Jobs Found")
                .font(.headline)
            Text("Try adjusting your search or add a new job.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.jlCard)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }
}
