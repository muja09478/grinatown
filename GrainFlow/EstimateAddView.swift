import SwiftUI


@available(iOS 14.0, *)
struct EstimateAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var data: CarpenterDataManager

    @State private var jobID: UUID? = nil
    @State private var clientID: UUID? = nil

    @State private var issueDate: Date = Date()
    @State private var validUntil: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()

    @State private var status: String = "Draft"
    @State private var totalCost: String = ""
    @State private var laborCost: String = ""
    @State private var materialCost: String = ""
    @State private var toolCost: String = ""
    @State private var taxAmount: String = ""
    @State private var discount: String = ""
    @State private var grandTotal: String = ""
    @State private var notes: String = ""
    @State private var currency: String = "USD"
    @State private var version: Int = 1

    @State private var referenceCode: String = ""
    @State private var preparedBy: String = ""
    @State private var approvedBy: String = ""
    @State private var approvalStatus: String = "Pending"

    @State private var revisionNotes: String = ""
    @State private var validityPeriod: Int = 30
    @State private var paymentTerms: String = "30 days"
    @State private var warrantyTerms: String = "1 year"
    @State private var deliverySchedule: String = "Within 2 weeks"
    @State private var riskAssessment: String = "Low"
    @State private var complianceNotes: String = "Compliant"
    @State private var legalClauses: String = "Standard terms"
    @State private var insuranceDetails: String = ""
    @State private var specialDiscountReason: String = ""
    @State private var extraCharges: String = "0"
    @State private var supervisor: String = ""
    @State private var tagsText: String = "Estimate"
    @State private var archived: Bool = false

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                EstimateAddSectionHeaderView(systemIcon: "link", title: "Associations")
                associationPickers

                EstimateAddDatePickerView(icon: "calendar", title: "Issue Date", date: $issueDate)
                EstimateAddDatePickerView(icon: "calendar.badge.exclamationmark", title: "Valid Until", date: $validUntil)

                EstimateAddSectionHeaderView(systemIcon: "dollarsign.circle", title: "Financials")
                EstimateAddFieldView(icon: "dollarsign", label: "Total Cost", keyboard: .decimalPad, text: $totalCost)
                EstimateAddFieldView(icon: "wrench", label: "Labor Cost", keyboard: .decimalPad, text: $laborCost)
                EstimateAddFieldView(icon: "shippingbox", label: "Material Cost", keyboard: .decimalPad, text: $materialCost)
                EstimateAddFieldView(icon: "hammer", label: "Tool Cost", keyboard: .decimalPad, text: $toolCost)
                EstimateAddFieldView(icon: "percent", label: "Tax Amount", keyboard: .decimalPad, text: $taxAmount)
                EstimateAddFieldView(icon: "scissors", label: "Discount", keyboard: .decimalPad, text: $discount)
                EstimateAddFieldView(icon: "sum", label: "Grand Total", keyboard: .decimalPad, text: $grandTotal)
                EstimateAddFieldView(icon: "coloncurrencysign.circle", label: "Currency", text: $currency)

                // Meta
                EstimateAddSectionHeaderView(systemIcon: "info.circle", title: "Meta")
                EstimateAddFieldView(icon: "number.square", label: "Reference Code", text: $referenceCode)
                EstimateAddFieldView(icon: "person.text.rectangle", label: "Prepared By", text: $preparedBy)
                EstimateAddFieldView(icon: "person.crop.badge.checkmark", label: "Approved By", text: $approvedBy)
                EstimateAddFieldView(icon: "checkmark.seal", label: "Approval Status", text: $approvalStatus)
                EstimateCardRow(title: "Version & Validity", icon: "dial.low") {
                    Stepper("Version: \(version)", value: $version, in: 1...99)
                    Spacer()
                    Stepper("Validity: \(validityPeriod) days", value: $validityPeriod, in: 1...365)
                }

                EstimateAddSectionHeaderView(systemIcon: "doc.text", title: "Terms & Notes")
                EstimateAddFieldView(icon: "doc.badge.gearshape", label: "Payment Terms", text: $paymentTerms)
                EstimateAddFieldView(icon: "shield.checkerboard", label: "Warranty Terms", text: $warrantyTerms)
                EstimateAddFieldView(icon: "truck.box", label: "Delivery Schedule", text: $deliverySchedule)
                EstimateAddFieldView(icon: "exclamationmark.shield", label: "Risk Assessment", text: $riskAssessment)
                EstimateAddFieldView(icon: "checklist.checked", label: "Compliance Notes", text: $complianceNotes)
                EstimateAddFieldView(icon: "lock.doc", label: "Legal Clauses", text: $legalClauses)
                EstimateAddFieldView(icon: "doc.richtext", label: "Insurance Details", text: $insuranceDetails)
                EstimateAddFieldView(icon: "tag", label: "Tags (comma-separated)", text: $tagsText)
                EstimateAddFieldView(icon: "text.bubble", label: "Revision Notes", text: $revisionNotes)
                EstimateAddFieldView(icon: "note.text", label: "Notes", text: $notes)
                EstimateAddFieldView(icon: "gift.fill", label: "Special Discount Reason", text: $specialDiscountReason)
                EstimateAddFieldView(icon: "plusminus.circle", label: "Extra Charges", keyboard: .decimalPad, text: $extraCharges)

                EstimateCardRow(title: "Status & Archive", icon: "archivebox") {
                    Text("Status:")
                    TextField("e.g. Draft, Approved, Rejected", text: $status)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                    Toggle("Archived", isOn: $archived)
                }

                HStack(spacing: 12) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Cancel")
                        }
                        .foregroundColor(EstimateTheme.danger)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(EstimateTheme.danger.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    Button(action: save) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Estimate")
                                .bold()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(EstimateTheme.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .padding(.top, 12)
        }
        .background(EstimateTheme.bg.ignoresSafeArea())
        .navigationBarTitle("New Estimate", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Validation"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"), action: {
                    if alertMessage.contains("success") {
                        presentationMode.wrappedValue.dismiss()
                    }
                  }))
        }
    }

    private var associationPickers: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                EstimateAddSectionHeaderView(systemIcon: "person.crop.circle.badge.checkmark", title: "Client")
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(EstimateTheme.primary)
                    Picker(selection: Binding(
                        get: {
                            clientID ?? data.clients.first?.id
                        },
                        set: { clientID = $0 }
                    ), label: Text("Select Client")) {
                        ForEach(data.clients) { client in
                            Text(client.name).tag(client.id as UUID?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(EstimateTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            VStack(alignment: .leading, spacing: 6) {
                EstimateAddSectionHeaderView(systemIcon: "hammer", title: "Job")
                HStack {
                    Image(systemName: "hammer.fill")
                        .foregroundColor(EstimateTheme.accent)
                    Picker(selection: Binding(
                        get: {
                            jobID ?? data.jobListings.first?.id
                        },
                        set: { jobID = $0 }
                    ), label: Text("Select Job")) {
                        ForEach(data.jobListings) { job in
                            Text(job.referenceCode).tag(job.id as UUID?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(EstimateTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
        }
    }

    private func save() {
        let errors = validate()
        if !errors.isEmpty {
            alertMessage = "Please fix the following:\n• " + errors.joined(separator: "\n• ")
            showAlert = true
            return
        }

        let estimate = Estimate(
            jobID: jobID!,
            clientID: clientID!,
            issueDate: issueDate,
            validUntil: validUntil,
            status: status,
            totalCost: Double(totalCost) ?? 0,
            laborCost: Double(laborCost) ?? 0,
            materialCost: Double(materialCost) ?? 0,
            toolCost: Double(toolCost) ?? 0,
            taxAmount: Double(taxAmount) ?? 0,
            discount: Double(discount) ?? 0,
            grandTotal: Double(grandTotal) ?? 0,
            notes: notes,
            currency: currency,
            version: version,
            referenceCode: referenceCode,
            preparedBy: preparedBy,
            approvedBy: approvedBy,
            approvalStatus: approvalStatus,
            createdDate: Date(),
            updatedDate: Date(),
            revisionNotes: revisionNotes,
            validityPeriod: validityPeriod,
            paymentTerms: paymentTerms,
            warrantyTerms: warrantyTerms,
            deliverySchedule: deliverySchedule,
            riskAssessment: riskAssessment,
            complianceNotes: complianceNotes,
            legalClauses: legalClauses,
            insuranceDetails: insuranceDetails,
            specialDiscountReason: specialDiscountReason,
            extraCharges: Double(extraCharges) ?? 0,
            supervisor: supervisor,
            tags: tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            archived: archived
        )
        data.addEstimate(estimate)
        alertMessage = "Estimate saved successfully."
        showAlert = true
    }

    private func validate() -> [String] {
        var e: [String] = []

        if clientID == nil { e.append("Client is required") }
        if jobID == nil { e.append("Job is required") }
        if referenceCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { e.append("Reference Code is required") }
        if preparedBy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { e.append("Prepared By is required") }
        if currency.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { e.append("Currency is required") }
        if status.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { e.append("Status is required") }
        if paymentTerms.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { e.append("Payment Terms are required") }

        func requireNumber(_ s: String, name: String) {
            if Double(s) == nil { e.append("\(name) must be a number") }
        }
        requireNumber(totalCost, name: "Total Cost")
        requireNumber(laborCost, name: "Labor Cost")
        requireNumber(materialCost, name: "Material Cost")
        requireNumber(toolCost, name: "Tool Cost")
        requireNumber(taxAmount, name: "Tax Amount")
        requireNumber(discount, name: "Discount")
        requireNumber(grandTotal, name: "Grand Total")
        requireNumber(extraCharges, name: "Extra Charges")

        if validUntil < issueDate { e.append("Valid Until must be on or after Issue Date") }

        return e
    }
}
