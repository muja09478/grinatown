import SwiftUI

@available(iOS 14.0, *)
struct MaterialAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var manager: CarpenterDataManager
    
    // Fields
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var unit: String = ""
    @State private var quantity: String = ""
    @State private var costPerUnit: String = ""
    @State private var supplier: String = ""
    @State private var brand: String = ""
    @State private var purchaseDate: Date? = nil
    @State private var warrantyExpiry: Date? = nil
    @State private var storageLocation: String = ""
    @State private var reorderLevel: String = ""
    @State private var reorderQuantity: String = ""
    @State private var batchNumber: String = ""
    @State private var referenceCode: String = ""
    @State private var qualityStatus: String = ""
    @State private var inspectionDate: Date? = nil
    @State private var createdDate: Date = Date()
    @State private var updatedDate: Date = Date()
    @State private var color: String = ""
    @State private var size: String = ""
    @State private var weight: String = ""
    @State private var origin: String = ""
    @State private var complianceCertificate: String = ""
    @State private var notes: String = ""
    @State private var tagsCSV: String = ""
    @State private var lastModifiedBy: String = ""
    @State private var reservedForJobUUID: String = ""
    @State private var availabilityStatus: String = ""
    @State private var disposalDate: Date? = nil
    @State private var recycled: Bool = false
    @State private var unitPriceHistoryCSV: String = ""
    @State private var currency: String = "USD"
    @State private var archived: Bool = false
    
    // Alert
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let currencies = ["USD", "EUR", "GBP", "JPY"]
    let qualities = ["Excellent", "Good", "Fair"]
    let statuses = ["Available", "Reserved", "Archived"]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [MaterialTheme.surface2, MaterialTheme.surface]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    header
                    
                    sectionHeader(title: "Basics", icon: "cube.box.fill")
                    Group {
                        floatingField(icon: "textformat", label: "Name*", text: $name)
                        floatingField(icon: "square.grid.2x2.fill", label: "Category*", text: $category)
                        HStack(spacing: 12) {
                            floatingField(icon: "scalemass.fill", label: "Unit*", text: $unit)
                            floatingField(icon: "number", label: "Quantity*", text: $quantity, keyboard: .numberPad)
                        }
                        HStack(spacing: 12) {
                            floatingField(icon: "dollarsign.circle.fill", label: "Cost Per Unit*", text: $costPerUnit, keyboard: .decimalPad)
                            pickerField(icon: "coloncurrencysign.circle", label: "Currency*", selection: $currency, options: currencies)
                        }
                    }
                    
                    sectionHeader(title: "Logistics", icon: "shippingbox.fill")
                    Group {
                        floatingField(icon: "building.2.fill", label: "Supplier*", text: $supplier)
                        floatingField(icon: "tag.fill", label: "Brand*", text: $brand)
                        floatingField(icon: "location.fill", label: "Storage Location*", text: $storageLocation)
                        HStack(spacing: 12) {
                            floatingField(icon: "exclamationmark.triangle.fill", label: "Reorder Level*", text: $reorderLevel, keyboard: .numberPad)
                            floatingField(icon: "arrow.down.circle.fill", label: "Reorder Quantity*", text: $reorderQuantity, keyboard: .numberPad)
                        }
                        floatingField(icon: "barcode.viewfinder", label: "Batch Number*", text: $batchNumber)
                        floatingField(icon: "number.circle", label: "Reference Code*", text: $referenceCode)
                    }
                    
                    sectionHeader(title: "Quality & Dates", icon: "checkmark.seal.fill")
                    Group {
                        pickerField(icon: "star.circle.fill", label: "Quality Status*", selection: $qualityStatus, options: qualities)
                        datePickerField(icon: "calendar.badge.plus", label: "Purchase Date", date: $purchaseDate)
                        datePickerField(icon: "calendar.circle", label: "Warranty Expiry", date: $warrantyExpiry)
                        datePickerField(icon: "calendar.badge.exclamationmark", label: "Inspection Date", date: $inspectionDate)
                    }
                    
                    sectionHeader(title: "Attributes", icon: "slider.horizontal.3")
                    Group {
                        HStack(spacing: 12) {
                            floatingField(icon: "drop.fill", label: "Color*", text: $color)
                            floatingField(icon: "square", label: "Size*", text: $size)
                        }
                        floatingField(icon: "scalemass", label: "Weight (kg)*", text: $weight, keyboard: .decimalPad)
                        floatingField(icon: "globe", label: "Origin*", text: $origin)
                        floatingField(icon: "doc.plaintext", label: "Compliance Certificate*", text: $complianceCertificate)
                        floatingTextArea(icon: "note.text", label: "Notes", text: $notes)
                    }
                    
                    sectionHeader(title: "Advanced", icon: "gearshape.2.fill")
                    Group {
                        floatingField(icon: "person.fill", label: "Last Modified By*", text: $lastModifiedBy)
                        floatingField(icon: "doc.text.magnifyingglass", label: "Reserved For Job (UUID)", text: $reservedForJobUUID)
                        pickerField(icon: "bolt.horizontal.circle.fill", label: "Availability Status*", selection: $availabilityStatus, options: statuses)
                        datePickerField(icon: "trash.circle.fill", label: "Disposal Date", date: $disposalDate)
                        
                        toggleField(icon: "arrow.2.squarepath", label: "Recycled", isOn: $recycled)
                        toggleField(icon: "archivebox.fill", label: "Archived", isOn: $archived)
                        
                        floatingField(icon: "tag.circle.fill", label: "Tags (comma-separated)", text: $tagsCSV)
                        floatingField(icon: "chart.line.uptrend.xyaxis", label: "Unit Price History (comma-separated)", text: $unitPriceHistoryCSV)
                    }
                    
                    Button(action: save) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Material")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(MaterialTheme.primary)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: MaterialTheme.primary.opacity(0.5), radius: 10, x: 0, y: 6)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Material"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"), action: {
                    if alertMessage.hasPrefix("Saved") {
                        presentationMode.wrappedValue.dismiss()
                    }
                  }))
        }
    }
    
    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "cube.box.fill")
                .foregroundColor(MaterialTheme.accent)
                .imageScale(.large)
            VStack(alignment: .leading, spacing: 4) {
                Text("Create a New Material")
                    .font(.title3).bold()
                    .foregroundColor(MaterialTheme.textPrimary)
                Text("Fill in all required fields marked with *")
                    .font(.footnote)
                    .foregroundColor(MaterialTheme.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(MaterialTheme.accent)
            Text(title)
                .foregroundColor(MaterialTheme.textPrimary)
                .font(.headline)
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal)
    }
    
    private func floatingField(icon: String, label: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(MaterialTheme.primary)
                Text(label).font(.caption).foregroundColor(MaterialTheme.textSecondary)
            }
            ZStack(alignment: .leading) {
                if text.wrappedValue.isEmpty {
                    Text(label.replacingOccurrences(of: "*", with: ""))
                        .foregroundColor(MaterialTheme.textSecondary.opacity(0.6))
                }
                TextField("", text: text)
                    .foregroundColor(MaterialTheme.textPrimary)
                    .keyboardType(keyboard)
            }
            .padding(12)
            .background(MaterialTheme.surface2)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private func floatingTextArea(icon: String, label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(MaterialTheme.primary)
                Text(label).font(.caption).foregroundColor(MaterialTheme.textSecondary)
            }
            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text("Enter \(label.lowercased())")
                        .foregroundColor(MaterialTheme.textSecondary.opacity(0.6))
                        .padding(12)
                }
                TextEditor(text: text)
                    .frame(minHeight: 80)
                    .foregroundColor(MaterialTheme.textPrimary)
                    .padding(8)
            }
            .background(MaterialTheme.surface2)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private func pickerField(icon: String, label: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(MaterialTheme.primary)
                Text(label).font(.caption).foregroundColor(MaterialTheme.textSecondary)
            }
            HStack {
                Picker("", selection: selection) {
                    ForEach(options, id: \.self) { o in
                        Text(o).tag(o)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(MaterialTheme.accent)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(MaterialTheme.textSecondary)
            }
            .padding(12)
            .background(MaterialTheme.surface2)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    // Date Picker
    private func datePickerField(icon: String, label: String, date: Binding<Date?>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(MaterialTheme.primary)
                Text(label).font(.caption).foregroundColor(MaterialTheme.textSecondary)
            }
            HStack {
                DatePicker("", selection: Binding(get: {
                    date.wrappedValue ?? Date()
                }, set: { newVal in
                    date.wrappedValue = newVal
                }), displayedComponents: .date)
                .labelsHidden()
                .accentColor(MaterialTheme.accent)
                Spacer()
                if date.wrappedValue != nil {
                    Button(action: { date.wrappedValue = nil }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(MaterialTheme.textSecondary)
                    }
                    .accessibilityLabel("Clear \(label)")
                }
            }
            .padding(12)
            .background(MaterialTheme.surface2)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    // Bool
    private func toggleField(icon: String, label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(MaterialTheme.primary)
                Text(label).foregroundColor(MaterialTheme.textPrimary)
            }
            Spacer()
            Toggle("", isOn: isOn).labelsHidden()
        }
        .padding(12)
        .background(MaterialTheme.surface2)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // Save action with validation and single alert
    private func save() {
        var errors: [String] = []
        
        // Validate required (>=15 fields)
        if name.isEmpty { errors.append("Name is required") }
        if category.isEmpty { errors.append("Category is required") }
        if unit.isEmpty { errors.append("Unit is required") }
        if Int(quantity) == nil || (Int(quantity) ?? 0) <= 0 { errors.append("Quantity must be a positive integer") }
        if Double(costPerUnit) == nil || (Double(costPerUnit) ?? -1) < 0 { errors.append("Cost Per Unit must be a valid number") }
        if supplier.isEmpty { errors.append("Supplier is required") }
        if brand.isEmpty { errors.append("Brand is required") }
        if storageLocation.isEmpty { errors.append("Storage Location is required") }
        if Int(reorderLevel) == nil || (Int(reorderLevel) ?? -1) < 0 { errors.append("Reorder Level must be ≥ 0") }
        if Int(reorderQuantity) == nil || (Int(reorderQuantity) ?? 0) <= 0 { errors.append("Reorder Quantity must be > 0") }
        if batchNumber.isEmpty { errors.append("Batch Number is required") }
        if referenceCode.isEmpty { errors.append("Reference Code is required") }
        if qualityStatus.isEmpty { errors.append("Quality Status is required") }
        if color.isEmpty { errors.append("Color is required") }
        if size.isEmpty { errors.append("Size is required") }
        if Double(weight) == nil || (Double(weight) ?? -1) < 0 { errors.append("Weight must be ≥ 0") }
        if origin.isEmpty { errors.append("Origin is required") }
        if complianceCertificate.isEmpty { errors.append("Compliance Certificate is required") }
        if lastModifiedBy.isEmpty { errors.append("Last Modified By is required") }
        if availabilityStatus.isEmpty { errors.append("Availability Status is required") }
        if currency.isEmpty { errors.append("Currency is required") }
        
        if !errors.isEmpty {
            alertMessage = errors.joined(separator: "\n• ")
            alertMessage = "Please fix the following:\n• " + alertMessage
            showAlert = true
            return
        }
        
        let tagList = tagsCSV
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let prices = unitPriceHistoryCSV
            .split(separator: ",")
            .compactMap { Double($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
        
        let reservedUUID: UUID? = UUID(uuidString: reservedForJobUUID)
        
        let new = Material(
            name: name,
            category: category,
            unit: unit,
            quantity: Int(quantity) ?? 0,
            costPerUnit: Double(costPerUnit) ?? 0,
            supplier: supplier,
            brand: brand,
            purchaseDate: purchaseDate,
            warrantyExpiry: warrantyExpiry,
            storageLocation: storageLocation,
            reorderLevel: Int(reorderLevel) ?? 0,
            reorderQuantity: Int(reorderQuantity) ?? 0,
            batchNumber: batchNumber,
            referenceCode: referenceCode,
            qualityStatus: qualityStatus,
            inspectionDate: inspectionDate,
            createdDate: createdDate,
            updatedDate: updatedDate,
            color: color,
            size: size,
            weight: Double(weight) ?? 0,
            origin: origin,
            complianceCertificate: complianceCertificate,
            notes: notes,
            tags: tagList,
            lastModifiedBy: lastModifiedBy,
            reservedForJob: reservedUUID,
            availabilityStatus: availabilityStatus,
            disposalDate: disposalDate,
            recycled: recycled,
            unitPriceHistory: prices,
            currency: currency,
            archived: archived
        )
        
        manager.addMaterial(new)
        alertMessage = "Saved successfully!"
        showAlert = true
    }
}
