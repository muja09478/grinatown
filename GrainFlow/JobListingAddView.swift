

import SwiftUI

@available(iOS 14.0, *)
struct JobListingAddView: View {
    @EnvironmentObject var manager: CarpenterDataManager

    @State private var title: String = ""
    @State private var descriptionText: String = ""
    @State private var clientIndex: Int = 0
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var status: String = "Planned"
    @State private var budget: String = ""
    @State private var location: String = ""
    @State private var priority: String = "Medium"
    @State private var category: String = "Furniture"
    @State private var assignedCarpenters: [String] = []
    @State private var carpenterInput: String = ""
    @State private var progress: Double = 0
    @State private var notes: String = ""
    @State private var referenceCode: String = ""
    @State private var estimatedHours: String = ""
    @State private var actualHours: String = "0"
    @State private var paymentStatus: String = "Pending"
    @State private var invoiceNumber: String = ""
    @State private var warrantyPeriod: String = "12 months"
    @State private var completionCertificate: Bool = false
    @State private var qualityCheckStatus: String = "Pending"
    @State private var safetyNotes: String = ""
    @State private var contractTerms: String = "Standard"
    @State private var discountOffered: String = "0"
    @State private var taxRate: String = "10"
    @State private var currency: String = "USD"
    @State private var revisionCount: String = "0"
    @State private var approvalStatus: String = "Pending"
    @State private var supervisor: String = ""
    @State private var department: String = ""
    @State private var tags: [String] = []
    @State private var tagInput: String = ""
    @State private var lastModifiedBy: String = "Admin"
    @State private var archived: Bool = false

    // Alert
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    let onSave: (JobListing) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Core Info
                JobListingAddSectionHeaderView(title: "Core Info", systemImage: "square.grid.2x2.fill")
                sectionCard {
                    JobListingAddFieldView(icon: "textformat", label: "Title", text: $title)
                    JobListingAddFieldView(icon: "text.alignleft", label: "Description", text: $descriptionText)
                    PickerField(title: "Client", icon: "person.crop.square", selection: $clientIndex, options: manager.clients.map { $0.name })
                    JobListingAddFieldView(icon: "mappin.and.ellipse", label: "Location", text: $location)
                    HStack(spacing: 12) {
                        PickerSegmented(title: "Priority", options: ["Low","Medium","High"], selection: $priority)
                        PickerSegmented(title: "Category", options: ["Furniture","Cabinetry","Repair"], selection: $category)
                    }
                }

                // Schedule & Progress
                JobListingAddSectionHeaderView(title: "Schedule & Progress", systemImage: "calendar.badge.clock")
                sectionCard {
                    JobListingAddDatePickerView(icon: "calendar", label: "Start Date", date: $startDate)
                    JobListingAddDatePickerView(icon: "calendar", label: "End Date", date: $endDate)
                    PickerSegmented(title: "Status", options: ["Planned","Ongoing","Completed"], selection: $status)
                    VStack(alignment: .leading) {
                        Text("Progress: \(Int(progress))%").font(.caption).foregroundColor(.secondary)
                        Slider(value: $progress, in: 0...100, step: 1)
                    }
                }

                // Financials
                JobListingAddSectionHeaderView(title: "Financials", systemImage: "dollarsign.circle.fill")
                sectionCard {
                    JobListingAddFieldView(icon: "dollarsign", label: "Budget", keyboard: .decimalPad, text: $budget)
                    JobListingAddFieldView(icon: "doc.text.fill", label: "Invoice Number", text: $invoiceNumber)
                    HStack(spacing: 12) {
                        JobListingAddFieldView(icon: "percent", label: "Discount %", keyboard: .decimalPad, text: $discountOffered)
                        JobListingAddFieldView(icon: "percent", label: "Tax %", keyboard: .decimalPad, text: $taxRate)
                        JobListingAddFieldView(icon: "coloncurrencysign.circle", label: "Currency", text: $currency)
                    }
                    PickerSegmented(title: "Payment", options: ["Pending","Partial","Paid"], selection: $paymentStatus)
                }

                // Quality & Safety
                JobListingAddSectionHeaderView(title: "Quality & Safety", systemImage: "checkmark.seal.fill")
                sectionCard {
                    PickerSegmented(title: "Quality", options: ["Pending","Passed","Failed"], selection: $qualityCheckStatus)
                    ToggleRow(title: "Completion Certificate", isOn: $completionCertificate)
                    JobListingAddFieldView(icon: "shield.lefthalf.fill", label: "Safety Notes", text: $safetyNotes)
                    JobListingAddFieldView(icon: "doc.text.magnifyingglass", label: "Contract Terms", text: $contractTerms)
                }

                // Workload & Team
                JobListingAddSectionHeaderView(title: "Workload & Team", systemImage: "person.3.fill")
                sectionCard {
                    HStack(spacing: 12) {
                        JobListingAddFieldView(icon: "clock.badge.checkmark", label: "Estimated Hours", keyboard: .numberPad, text: $estimatedHours)
                        JobListingAddFieldView(icon: "clock.fill", label: "Actual Hours", keyboard: .numberPad, text: $actualHours)
                    }
                    tagsEditor(title: "Assigned Carpenters", items: $assignedCarpenters, input: $carpenterInput, icon: "person.fill.badge.plus")
                }

                // Admin
                JobListingAddSectionHeaderView(title: "Admin & Metadata", systemImage: "gearshape.fill")
                sectionCard {
                    JobListingAddFieldView(icon: "number", label: "Reference Code", text: $referenceCode)
                    PickerSegmented(title: "Approval", options: ["Pending","Approved","Rejected"], selection: $approvalStatus)
                    HStack(spacing: 12) {
                        JobListingAddFieldView(icon: "person.badge.key.fill", label: "Supervisor", text: $supervisor)
                        JobListingAddFieldView(icon: "building.2.fill", label: "Department", text: $department)
                    }
                    JobListingAddFieldView(icon: "note.text", label: "Notes", text: $notes)
                    JobListingAddFieldView(icon: "person.fill", label: "Last Modified By", text: $lastModifiedBy)
                    ToggleRow(title: "Archived", isOn: $archived)
                    tagsEditor(title: "Tags", items: $tags, input: $tagInput, icon: "tag.fill")
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .navigationBarTitle("Add Job", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: saveTapped) {
                Text("Save")
                    .bold()
                    .foregroundColor(.blue)
            }.accessibilityLabel(Text("Save Job"))
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Validation"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - UI Helpers
    private func sectionCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12, content: content)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.green)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
    }

    private func tagsEditor(title: String, items: Binding<[String]>, input: Binding<String>, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon).foregroundColor(.blue).accessibilityHidden(true)
                Text(title).font(.subheadline).foregroundColor(.secondary)
                Spacer()
            }
            HStack(spacing: 10) {
                TextField("Add \(title.dropLast(title.hasSuffix("s") ? 1 : 0))", text: input)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple))
                Button(action: {
                    let trimmed = input.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    items.wrappedValue.append(trimmed)
                    input.wrappedValue = ""
                }) {
                    Image(systemName: "plus.circle.fill").foregroundColor(.green).font(.title3)
                }
                .accessibilityLabel(Text("Add \(title)"))
            }
            JobListingChipsView(items: items.wrappedValue, color: .blue)
        }
    }

    private func ToggleRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title).foregroundColor(.primary)
            Spacer()
            Toggle("", isOn: isOn).labelsHidden()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.yellow))
    }

    private func PickerSegmented(title: String, options: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.caption).foregroundColor(.secondary)
            Picker("", selection: selection) {
                ForEach(options, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    private func PickerField(title: String, icon: String, selection: Binding<Int>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.caption).foregroundColor(.secondary)
            HStack {
                Image(systemName: icon).foregroundColor(.blue).accessibilityHidden(true)
                Picker("", selection: selection) {
                    ForEach(0..<options.count, id: \.self) { idx in
                        Text(options[idx]).tag(idx)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                Spacer()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.red))
        }
    }

    // MARK: - Save
    private func saveTapped() {
        let errors = validate()
        if !errors.isEmpty {
            alertMessage = "Please fix the following:\n- " + errors.joined(separator: "\n- ")
            showAlert = true
            return
        }

        let client = manager.clients[min(clientIndex, max(0, manager.clients.count - 1))]

        let newJob = JobListing(
            title: title,
            description: descriptionText,
            clientID: client.id,
            startDate: startDate,
            endDate: endDate,
            status: status,
            budget: Double(budget) ?? 0,
            location: location,
            priority: priority,
            category: category,
            assignedCarpenters: assignedCarpenters,
            progress: Int(progress),
            notes: notes,
            referenceCode: referenceCode,
            createdDate: Date(),
            updatedDate: Date(),
            estimatedHours: Int(estimatedHours) ?? 0,
            actualHours: Int(actualHours) ?? 0,
            paymentStatus: paymentStatus,
            invoiceNumber: invoiceNumber,
            warrantyPeriod: warrantyPeriod,
            completionCertificate: completionCertificate,
            qualityCheckStatus: qualityCheckStatus,
            safetyNotes: safetyNotes,
            contractTerms: contractTerms,
            discountOffered: Double(discountOffered) ?? 0,
            taxRate: Double(taxRate) ?? 0,
            currency: currency,
            revisionCount: Int(revisionCount) ?? 0,
            approvalStatus: approvalStatus,
            supervisor: supervisor,
            department: department,
            tags: tags,
            lastModifiedBy: lastModifiedBy,
            archived: archived
        )

        onSave(newJob)
        alertMessage = "Job saved successfully."
        showAlert = true
    }

    private func validate() -> [String] {
        var errs: [String] = []
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errs.append("Title is required.") }
        if descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errs.append("Description is required.") }
        if manager.clients.isEmpty { errs.append("No clients available.") }
        if location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errs.append("Location is required.") }
        if referenceCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errs.append("Reference Code is required.") }
        if (Double(budget) ?? 0) <= 0 { errs.append("Budget must be greater than 0.") }
        if (Int(estimatedHours) ?? 0) <= 0 { errs.append("Estimated Hours must be greater than 0.") }
        if let s = startDate, let e = endDate, s > e { errs.append("End Date must be after Start Date.") }
        if currency.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errs.append("Currency is required.") }
        return errs
    }
}
