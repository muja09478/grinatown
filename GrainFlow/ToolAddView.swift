import SwiftUI

@available(iOS 14.0, *)
struct ToolAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var dataManager: CarpenterDataManager

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var serialNumber: String = ""
    @State private var model: String = ""
    @State private var brand: String = ""
    @State private var status: String = "Good"
    @State private var location: String = ""
    @State private var assignedTo: String = ""
    @State private var condition: String = "Excellent"
    @State private var usageHoursStr: String = ""
    @State private var referenceCode: String = ""
    @State private var notes: String = ""
    @State private var purchaseCostStr: String = ""
    @State private var supplier: String = ""
    @State private var safetyCertificate: String = ""
    @State private var insuranceDetails: String = ""
    @State private var tagsText: String = ""
    @State private var supervisor: String = ""
    @State private var department: String = ""
    @State private var availabilityStatus: String = "Available"
    @State private var reservedForJobStr: String = ""
    @State private var recycled: Bool = false
    @State private var depreciationRateStr: String = "5"
    @State private var currency: String = "USD"
    @State private var archived: Bool = false

    // Dates
    @State private var purchaseDate: Date = Date()
    @State private var warrantyExpiry: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    @State private var maintenanceDate: Date = Date()
    @State private var inspectionDate: Date = Date()
    @State private var calibrationDate: Date = Date()
    @State private var disposalDateEnabled: Bool = false
    @State private var disposalDate: Date = Date()

    // Alert
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    let onSave: (Tool) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ToolAddSectionHeaderView(title: "Identity", icon: "wrench.fill", color: ToolTheme.brandBlue)
                ToolAddFieldView(icon: "doc.text.fill", title: "Name", text: $name)
                ToolAddFieldView(icon: "number.square.fill", title: "Serial Number", text: $serialNumber, textContentType: .none)
                ToolAddFieldView(icon: "tag.fill", title: "Category", text: $category)
                ToolAddFieldView(icon: "wrench.and.screwdriver.fill", title: "Model", text: $model)
                ToolAddFieldView(icon: "building.2.fill", title: "Brand", text: $brand)

                ToolAddSectionHeaderView(title: "Status & Assignment", icon: "person.crop.circle.fill", color: ToolTheme.accentTeal)
                ToolAddFieldView(icon: "checkmark.seal.fill", title: "Status", text: $status)
                ToolAddFieldView(icon: "mappin.and.ellipse", title: "Location", text: $location)
                ToolAddFieldView(icon: "person.fill", title: "Assigned To", text: $assignedTo)
                ToolAddFieldView(icon: "timelapse", title: "Usage Hours", text: $usageHoursStr, keyboard: .numberPad)

                ToolAddSectionHeaderView(title: "Financial", icon: "creditcard.fill", color: ToolTheme.accentOrange)
                ToolAddFieldView(icon: "textformat.123", title: "Purchase Cost", text: $purchaseCostStr, keyboard: .decimalPad)
                ToolAddFieldView(icon: "dollarsign.circle.fill", title: "Currency", text: $currency)
                ToolAddFieldView(icon: "shippingbox.fill", title: "Supplier", text: $supplier)
                ToolAddFieldView(icon: "percent", title: "Depreciation %", text: $depreciationRateStr, keyboard: .decimalPad)

                ToolAddSectionHeaderView(title: "Compliance & Docs", icon: "shield.lefthalf.fill", color: ToolTheme.brandBlue)
                ToolAddFieldView(icon: "checkmark.seal.fill", title: "Safety Certificate", text: $safetyCertificate)
                ToolAddFieldView(icon: "doc.richtext.fill", title: "Insurance Details", text: $insuranceDetails)

                ToolAddSectionHeaderView(title: "Admin", icon: "rectangle.and.pencil.and.ellipsis", color: ToolTheme.accentTeal)
                ToolAddFieldView(icon: "number", title: "Reference Code", text: $referenceCode)
                ToolAddFieldView(icon: "person.2.fill", title: "Supervisor", text: $supervisor)
                ToolAddFieldView(icon: "building.columns.fill", title: "Department", text: $department)
                ToolAddFieldView(icon: "flag.checkered", title: "Availability", text: $availabilityStatus)
                ToolAddFieldView(icon: "tag.circle.fill", title: "Tags (comma separated)", text: $tagsText)
                ToolAddFieldView(icon: "text.bubble.fill", title: "Notes", text: $notes)
                ToolAddFieldView(icon: "link", title: "Reserved For Job (UUID)", text: $reservedForJobStr, textContentType: .none)

                ToolAddSectionHeaderView(title: "Dates", icon: "calendar", color: ToolTheme.accentOrange)
                ToolAddDatePickerView(icon: "calendar.badge.plus", title: "Purchase Date", date: $purchaseDate)
                ToolAddDatePickerView(icon: "checkmark.shield.fill", title: "Warranty Expiry", date: $warrantyExpiry)
                ToolAddDatePickerView(icon: "wrench.and.screwdriver.fill", title: "Maintenance Date", date: $maintenanceDate)
                ToolAddDatePickerView(icon: "eye.fill", title: "Inspection Date", date: $inspectionDate)
                ToolAddDatePickerView(icon: "gauge", title: "Calibration Date", date: $calibrationDate)

                ToolAddSectionHeaderView(title: "Flags", icon: "switch.2", color: ToolTheme.brandBlue)
                Toggle(isOn: $recycled) {
                    HStack {
                        Image(systemName: "arrow.2.circlepath.circle.fill").foregroundColor(ToolTheme.accentTeal)
                        Text("Recycled")
                            .font(.subheadline).foregroundColor(.primary)
                    }
                }
                Toggle(isOn: $archived) {
                    HStack {
                        Image(systemName: "archivebox.fill").foregroundColor(ToolTheme.brandBlue)
                        Text("Archived")
                            .font(.subheadline).foregroundColor(.primary)
                    }
                }
                Toggle(isOn: $disposalDateEnabled) {
                    HStack {
                        Image(systemName: "trash.fill").foregroundColor(ToolTheme.accentOrange)
                        Text("Set Disposal Date")
                            .font(.subheadline).foregroundColor(.primary)
                    }
                }
                if disposalDateEnabled {
                    ToolAddDatePickerView(icon: "trash.slash.fill", title: "Disposal Date", date: $disposalDate)
                }

                Button(action: save) {
                    HStack {
                        Image(systemName: "tray.and.arrow.down.fill")
                        Text("Save Tool")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(ToolTheme.brandBlue)
                    .cornerRadius(12)
                    .accessibility(label: Text("Save Tool"))
                }
                .padding(.top, 6)
            }
            .padding(16)
        }
        .navigationBarTitle("Add Tool", displayMode: .inline)
        .navigationBarItems(leading: Button("Close") { presentationMode.wrappedValue.dismiss() })
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                if alertTitle == "Saved" {
                    presentationMode.wrappedValue.dismiss()
                }
            }))
        }
    }

    private func save() {
        var errors: [String] = []

        let usageHours = Int(usageHoursStr) ?? -1
        if name.isEmpty { errors.append("Name is required.") }
        if category.isEmpty { errors.append("Category is required.") }
        if serialNumber.isEmpty { errors.append("Serial Number is required.") }
        if model.isEmpty { errors.append("Model is required.") }
        if brand.isEmpty { errors.append("Brand is required.") }
        if status.isEmpty { errors.append("Status is required.") }
        if location.isEmpty { errors.append("Location is required.") }
        if condition.isEmpty { errors.append("Condition is required.") }
        if usageHours < 0 { errors.append("Usage Hours must be a non-negative whole number.") }
        let purchaseCost = Double(purchaseCostStr) ?? -1
        if purchaseCost < 0 { errors.append("Purchase Cost must be a valid number.") }
        let depreciationRate = Double(depreciationRateStr) ?? -1
        if depreciationRate < 0 { errors.append("Depreciation % must be a valid number.") }
        if referenceCode.isEmpty { errors.append("Reference Code is required.") }
        if supervisor.isEmpty { errors.append("Supervisor is required.") }
        if department.isEmpty { errors.append("Department is required.") }
        if availabilityStatus.isEmpty { errors.append("Availability is required.") }
        if warrantyExpiry < purchaseDate { errors.append("Warranty Expiry must be after Purchase Date.") }

        var reservedUUID: UUID? = nil
        if !reservedForJobStr.trimmingCharacters(in: .whitespaces).isEmpty {
            if let uid = UUID(uuidString: reservedForJobStr) {
                reservedUUID = uid
            } else {
                errors.append("Reserved For Job must be a valid UUID.")
            }
        }

        if !errors.isEmpty {
            alertTitle = "Please fix the following"
            alertMessage = "• " + errors.joined(separator: "\n• ")
            showAlert = true
            return
        }

        let tags = tagsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let now = Date()
        let tool = Tool(
            name: name,
            category: category,
            serialNumber: serialNumber,
            model: model,
            brand: brand,
            purchaseDate: purchaseDate,
            warrantyExpiry: warrantyExpiry,
            status: status,
            location: location,
            assignedTo: assignedTo,
            maintenanceDate: maintenanceDate,
            condition: condition,
            usageHours: usageHours,
            referenceCode: referenceCode,
            notes: notes,
            createdDate: now,
            updatedDate: now,
            purchaseCost: purchaseCost,
            supplier: supplier,
            inspectionDate: inspectionDate,
            calibrationDate: calibrationDate,
            safetyCertificate: safetyCertificate,
            insuranceDetails: insuranceDetails,
            tags: tags,
            supervisor: supervisor,
            department: department,
            availabilityStatus: availabilityStatus,
            reservedForJob: reservedUUID,
            disposalDate: disposalDateEnabled ? disposalDate : nil,
            recycled: recycled,
            depreciationRate: depreciationRate,
            currency: currency,
            archived: archived
        )

        onSave(tool)
        alertTitle = "Saved"
        alertMessage = "Your tool has been saved successfully."
        showAlert = true
    }
}

@available(iOS 14.0, *)
struct ToolAddSectionHeaderView: View {
    let title: String
    let icon: String
    let color: Color
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .bold))
                .frame(width: 28, height: 28)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
struct ToolAddFieldView: View {
    let icon: String
    let title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var textContentType: UITextContentType? = .none

    @State private var isFocused: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(ToolTheme.brandBlue)
                    .frame(width: 20)
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(title)
                            .foregroundColor(.secondary)
                            .padding(.leading, 2)
                    }
                    TextField("", text: $text, onEditingChanged: { editing in
                        withAnimation(.easeInOut(duration: 0.15)) { isFocused = editing }
                    })
                    .keyboardType(keyboard)
                    .textContentType(textContentType)
                    .autocapitalization(.none)
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? ToolTheme.brandBlue : ToolTheme.brandBlue.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }
}

@available(iOS 14.0, *)
struct ToolAddDatePickerView: View {
    let icon: String
    let title: String
    @Binding var date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(ToolTheme.accentTeal)
                    .frame(width: 20)
                DatePicker(title, selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .accessibility(label: Text(title))
            }
            .padding(12)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ToolTheme.brandBlue.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }
}
