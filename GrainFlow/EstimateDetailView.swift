import SwiftUI


@available(iOS 14.0, *)
struct EstimateDetailView: View {
    @ObservedObject var data: CarpenterDataManager
    let estimate: Estimate

    private func clientName() -> String {
        data.clients.first(where: { $0.id == estimate.clientID })?.name ?? "Unknown Client"
    }
    private func jobCode() -> String {
        data.jobListings.first(where: { $0.id == estimate.jobID })?.referenceCode ?? "N/A"
    }
    private func dateString(_ d: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: d)
    }

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Hero Header
                header

                // Overview
                groupCard(title: "Overview", icon: "doc.text.magnifyingglass") {
                    LazyVGrid(columns: columns, spacing: 12) {
                        EstimateDetailFieldRow(icon: "number.square", title: "Reference Code", value: estimate.referenceCode)
                        EstimateDetailFieldRow(icon: "person.circle", title: "Client", value: clientName())
                        EstimateDetailFieldRow(icon: "hammer", title: "Job", value: jobCode())
                        EstimateDetailFieldRow(icon: "calendar", title: "Issue Date", value: dateString(estimate.issueDate))
                        EstimateDetailFieldRow(icon: "calendar.badge.exclamationmark", title: "Valid Until", value: dateString(estimate.validUntil))
                        EstimateDetailFieldRow(icon: "checkmark.seal", title: "Approval Status", value: estimate.approvalStatus)
                        EstimateDetailFieldRow(icon: "seal", title: "Status", value: estimate.status)
                        EstimateDetailFieldRow(icon: "number.circle", title: "Version", value: "\(estimate.version)")
                    }
                }

                // Financials
                groupCard(title: "Financials", icon: "dollarsign.circle") {
                    LazyVGrid(columns: columns, spacing: 12) {
                        EstimateDetailFieldRow(icon: "dollarsign.circle", title: "Total Cost", value: "\(estimate.totalCost)")
                        EstimateDetailFieldRow(icon: "wrench", title: "Labor Cost", value: "\(estimate.laborCost)")
                        EstimateDetailFieldRow(icon: "shippingbox", title: "Material Cost", value: "\(estimate.materialCost)")
                        EstimateDetailFieldRow(icon: "hammer", title: "Tool Cost", value: "\(estimate.toolCost)")
                        EstimateDetailFieldRow(icon: "percent", title: "Tax Amount", value: "\(estimate.taxAmount)")
                        EstimateDetailFieldRow(icon: "scissors", title: "Discount", value: "\(estimate.discount)")
                        EstimateDetailFieldRow(icon: "sum", title: "Grand Total", value: "\(estimate.grandTotal)")
                        EstimateDetailFieldRow(icon: "coloncurrencysign.circle", title: "Currency", value: estimate.currency)
                        EstimateDetailFieldRow(icon: "plusminus.circle", title: "Extra Charges", value: "\(estimate.extraCharges)")
                    }
                }

                // Personnel & Meta
                groupCard(title: "Personnel & Meta", icon: "person.2.circle") {
                    LazyVGrid(columns: columns, spacing: 12) {
                        EstimateDetailFieldRow(icon: "person.text.rectangle", title: "Prepared By", value: estimate.preparedBy)
                        EstimateDetailFieldRow(icon: "person.crop.badge.checkmark", title: "Approved By", value: estimate.approvedBy)
                        EstimateDetailFieldRow(icon: "person.badge.shield.checkmark", title: "Supervisor", value: estimate.supervisor)
                        EstimateDetailFieldRow(icon: "calendar.badge.plus", title: "Created", value: dateString(estimate.createdDate))
                        EstimateDetailFieldRow(icon: "calendar.badge.clock", title: "Updated", value: dateString(estimate.updatedDate))
                        EstimateDetailFieldRow(icon: "clock.arrow.circlepath", title: "Validity (days)", value: "\(estimate.validityPeriod)")
                        EstimateDetailFieldRow(icon: "archivebox", title: "Archived", value: estimate.archived ? "Yes" : "No")
                        EstimateDetailFieldRow(icon: "number.square.fill", title: "Version", value: "\(estimate.version)")
                    }
                }

                // Terms & Compliance
                groupCard(title: "Terms & Compliance", icon: "checklist.checked") {
                    VStack(spacing: 12) {
                        EstimateDetailFieldRow(icon: "doc.badge.gearshape", title: "Payment Terms", value: estimate.paymentTerms)
                        EstimateDetailFieldRow(icon: "shield.checkerboard", title: "Warranty Terms", value: estimate.warrantyTerms)
                        EstimateDetailFieldRow(icon: "truck.box", title: "Delivery Schedule", value: estimate.deliverySchedule)
                        EstimateDetailFieldRow(icon: "exclamationmark.shield", title: "Risk Assessment", value: estimate.riskAssessment)
                        EstimateDetailFieldRow(icon: "checkmark.shield", title: "Compliance Notes", value: estimate.complianceNotes)
                        EstimateDetailFieldRow(icon: "lock.doc", title: "Legal Clauses", value: estimate.legalClauses)
                        EstimateDetailFieldRow(icon: "doc.richtext", title: "Insurance Details", value: estimate.insuranceDetails)
                        EstimateDetailFieldRow(icon: "text.bubble", title: "Revision Notes", value: estimate.revisionNotes)
                        EstimateDetailFieldRow(icon: "note.text", title: "Notes", value: estimate.notes)
                        if !estimate.specialDiscountReason.isEmpty {
                            EstimateDetailFieldRow(icon: "gift.fill", title: "Special Discount Reason", value: estimate.specialDiscountReason)
                        }
                        if !estimate.tags.isEmpty {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "tag")
                                    .foregroundColor(EstimateTheme.accent)
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Tags")
                                        .font(.footnote).bold()
                                        .foregroundColor(EstimateTheme.textPrimary)
                                    WrapTagsView(tags: estimate.tags)
                                }
                                Spacer()
                            }
                            .padding(10)
                            .background(EstimateTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(Text("Tags \(estimate.tags.joined(separator: ", "))"))
                        }
                    }
                }
            }
            .padding()
        }
        .background(EstimateTheme.bg.ignoresSafeArea())
        .navigationBarTitle("Estimate Details", displayMode: .inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(EstimateTheme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text(estimate.referenceCode)
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Spacer()
                Text(estimate.status.uppercased())
                    .font(.caption).bold()
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(EstimateTheme.accent)
                    .clipShape(Capsule())
            }
            Text(clientName())
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.85))
        }
        .padding()
        .background(EstimateTheme.primary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: EstimateTheme.primary.opacity(0.25), radius: 12, x: 0, y: 8)
    }

    private func groupCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(EstimateTheme.primary)
                    .padding(8)
                    .background(EstimateTheme.primary.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Text(title)
                    .font(.headline)
                    .foregroundColor(EstimateTheme.textPrimary)
                Spacer()
            }
            content()
        }
        .padding()
        .background(EstimateTheme.bg)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(EstimateTheme.card, lineWidth: 1)
        )
        .background(EstimateTheme.card.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct WrapTagsView: View {
    let tags: [String]
    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        self.generateContent()
            .frame(height: totalHeight)
    }

    private func generateContent() -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                tagView(tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading) { d in
                      
                        defer { width += d.width }
                        return width
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        return result
                    }
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear.onAppear {
                    totalHeight = geo.size.height
                }
            }
        )
    }

    private func tagView(_ text: String) -> some View {
        Text(text)
            .font(.caption).bold()
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(EstimateTheme.accent.opacity(0.12))
            .foregroundColor(EstimateTheme.accent)
            .clipShape(Capsule())
    }
}
