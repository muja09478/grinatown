
import SwiftUI

@available(iOS 14.0, *)
struct AuditEntryAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var store: CarpenterDataManager

    @State private var entityType = ""
    @State private var action = ""
    @State private var performedBy = ""
    @State private var reason = ""
    @State private var oldValue = ""
    @State private var newValue = ""
    @State private var device = ""
    @State private var ipAddress = ""
    @State private var location = ""
    @State private var sessionID = ""
    @State private var appVersion = ""
    @State private var osVersion = ""
    @State private var referenceCode = ""
    @State private var approvalStatus = ""
    @State private var approvedBy = ""
    @State private var supervisor = ""
    @State private var department = ""
    @State private var notes = ""
    @State private var rejectionReason = ""

    @State private var severity = "Low"
    @State private var complianceStatus = "OK"

    @State private var timestamp = Date()
    @State private var followUpDate = Date()

    @State private var archived = false
    @State private var tagsInput = "" // comma separated
    @State private var entityIDString = UUID().uuidString
    @State private var relatedJobIDString = ""
    @State private var relatedClientIDString = ""
    @State private var relatedToolIDString = ""
    @State private var relatedMaterialIDString = ""

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private let severityOptions = ["Low", "Medium", "High", "Critical"]
    private let complianceOptions = ["OK", "Warning", "Violation"]

    var body: some View {
        NavigationView {
            ZStack {
                AETheme.bgSoft.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        // Identity
                        AuditEntryAddSectionHeaderView(title: "Identity", systemImage: "person.text.rectangle")
                        AuditEntryAddFieldView(label: "Entity Type", systemImage: "cube.box.fill", placeholder: "e.g. Job / Client / Tool", text: $entityType)
                        AuditEntryAddFieldView(label: "Action", systemImage: "bolt.fill", placeholder: "e.g. Created / Updated / Deleted", text: $action)
                        AuditEntryAddFieldView(label: "Performed By", systemImage: "person.crop.circle.fill", placeholder: "Username or ID", text: $performedBy)
                        AuditEntryAddDatePickerView(label: "Timestamp", systemImage: "calendar.badge.clock", date: $timestamp)
                        AuditEntryAddFieldView(label: "Entity ID (UUID)", systemImage: "number.circle.fill", placeholder: "Paste or keep generated", text: $entityIDString)

                        // Context
                        AuditEntryAddSectionHeaderView(title: "Context", systemImage: "info.circle.fill")
                        AuditEntryAddFieldView(label: "Reason", systemImage: "text.badge.checkmark", placeholder: "Why did this happen?", text: $reason)
                        AuditEntryAddFieldView(label: "Old Value", systemImage: "arrow.uturn.backward.circle.fill", placeholder: "Previous value (optional)", text: $oldValue)
                        AuditEntryAddFieldView(label: "New Value", systemImage: "arrow.uturn.forward.circle.fill", placeholder: "New value", text: $newValue)
                        AuditEntryAddFieldView(label: "Device", systemImage: "iphone", placeholder: "e.g. iPhone 12", text: $device)
                        AuditEntryAddFieldView(label: "IP Address", systemImage: "network", placeholder: "e.g. 192.168.1.1", text: $ipAddress)
                        AuditEntryAddFieldView(label: "Location", systemImage: "mappin.and.ellipse", placeholder: "e.g. HQ Office", text: $location)
                        AuditEntryAddFieldView(label: "Session ID", systemImage: "rectangle.badge.person.crop", placeholder: "e.g. SESSION123", text: $sessionID)
                        AuditEntryAddFieldView(label: "App Version", systemImage: "app.badge.fill", placeholder: "e.g. 1.0.0", text: $appVersion)
                        AuditEntryAddFieldView(label: "OS Version", systemImage: "gearshape.2.fill", placeholder: "e.g. iOS 14.8", text: $osVersion)
                        AuditEntryAddFieldView(label: "Reference Code", systemImage: "barcode.viewfinder", placeholder: "Internal reference", text: $referenceCode)

                        // Status
                        AuditEntryAddSectionHeaderView(title: "Status & Compliance", systemImage: "checkmark.seal.fill")
                        AuditEntryAddFieldView(label: "Approval Status", systemImage: "checkmark.shield.fill", placeholder: "e.g. Approved / Pending", text: $approvalStatus)
                        AuditEntryAddFieldView(label: "Approved By", systemImage: "signature", placeholder: "Approver name", text: $approvedBy)
                        AuditEntryAddFieldView(label: "Rejection Reason", systemImage: "xmark.seal.fill", placeholder: "If rejected", text: $rejectionReason)
                        AuditEntryChipPicker(label: "Severity", systemImage: "exclamationmark.triangle.fill", options: severityOptions, selection: $severity)
                        AuditEntryChipPicker(label: "Compliance", systemImage: "checkmark.circle.fill", options: complianceOptions, selection: $complianceStatus)
                        AuditEntryAddDatePickerView(label: "Follow-up Date", systemImage: "calendar.badge.plus", date: $followUpDate)

                        // Organization
                        AuditEntryAddSectionHeaderView(title: "Organization", systemImage: "building.2.fill")
                        AuditEntryAddFieldView(label: "Supervisor", systemImage: "person.2.badge.gearshape.fill", placeholder: "Supervisor name", text: $supervisor)
                        AuditEntryAddFieldView(label: "Department", systemImage: "list.bullet.rectangle.portrait.fill", placeholder: "Department name", text: $department)
                        Toggle(isOn: $archived) {
                            HStack(spacing: 8) {
                                Image(systemName: "archivebox.fill")
                                    .foregroundColor(AETheme.accentOrange)
                                Text("Archived")
                                    .foregroundColor(AETheme.textPrimary)
                                    .font(.body)
                            }
                        }
                        .padding()
                        .background(AETheme.card)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)

                        // Relations & Tags
                        AuditEntryAddSectionHeaderView(title: "Relations & Tags", systemImage: "link")
                        AuditEntryAddFieldView(label: "Related Job ID (UUID)", systemImage: "wrench.and.screwdriver.fill", placeholder: "Optional", text: $relatedJobIDString)
                        AuditEntryAddFieldView(label: "Related Client ID (UUID)", systemImage: "person.3.fill", placeholder: "Optional", text: $relatedClientIDString)
                        AuditEntryAddFieldView(label: "Related Tool ID (UUID)", systemImage: "hammer.fill", placeholder: "Optional", text: $relatedToolIDString)
                        AuditEntryAddFieldView(label: "Related Material ID (UUID)", systemImage: "shippingbox.fill", placeholder: "Optional", text: $relatedMaterialIDString)
                        AuditEntryAddFieldView(label: "Tags", systemImage: "tag.fill", placeholder: "Comma-separated", text: $tagsInput)

                        // Notes
                        AuditEntryAddSectionHeaderView(title: "Notes", systemImage: "note.text")
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AETheme.card)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "note.text")
                                        .foregroundColor(AETheme.brand)
                                    Text("Notes")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                TextEditor(text: $notes)
                                    .frame(minHeight: 96)
                                    .foregroundColor(AETheme.textPrimary)
                            }
                            .padding(14)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)

                        Button(action: save) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Audit Entry")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AETheme.brand)
                            .cornerRadius(14)
                            .padding(.horizontal)
                            .shadow(color: AETheme.brand.opacity(0.3), radius: 10, x: 0, y: 6)
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationBarTitle("New Audit Entry", displayMode: .inline)
            .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                    if alertTitle == "Success" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
        }
    }

    private func save() {
        var errors: [String] = []

        func require(_ value: String, _ name: String) {
            if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.append(name)
            }
        }

        // 15+ required fields
        require(entityType, "Entity Type")
        require(action, "Action")
        require(performedBy, "Performed By")
        require(reason, "Reason")
        require(newValue, "New Value")
        require(device, "Device")
        require(ipAddress, "IP Address")
        require(location, "Location")
        require(sessionID, "Session ID")
        require(appVersion, "App Version")
        require(osVersion, "OS Version")
        require(referenceCode, "Reference Code")
        require(approvalStatus, "Approval Status")
        require(supervisor, "Supervisor")
        require(department, "Department")

        let ipv4 = #"^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$"#
        if ipAddress.range(of: ipv4, options: .regularExpression) == nil {
            errors.append("IP Address (invalid format)")
        }

        guard let entityUUID = UUID(uuidString: entityIDString) else {
            errors.append("Entity ID (UUID)")
            showValidation(errors)
            return
        }

        if !errors.isEmpty {
            showValidation(errors)
            return
        }

        let now = Date()
        let entry = AuditEntry(
            entityType: entityType,
            entityID: entityUUID,
            action: action,
            performedBy: performedBy,
            timestamp: timestamp,
            reason: reason,
            oldValue: oldValue,
            newValue: newValue,
            device: device,
            ipAddress: ipAddress,
            location: location,
            sessionID: sessionID,
            appVersion: appVersion,
            osVersion: osVersion,
            referenceCode: referenceCode,
            createdDate: now,
            updatedDate: now,
            approvalStatus: approvalStatus,
            approvedBy: approvedBy,
            rejectionReason: rejectionReason,
            tags: tagsInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
            relatedJobID: UUID(uuidString: relatedJobIDString),
            relatedClientID: UUID(uuidString: relatedClientIDString),
            relatedToolID: UUID(uuidString: relatedToolIDString),
            relatedMaterialID: UUID(uuidString: relatedMaterialIDString),
            supervisor: supervisor,
            department: department,
            archived: archived,
            notes: notes,
            severity: severity,
            complianceStatus: complianceStatus,
            correctiveAction: "",
            followUpDate: followUpDate
        )

      
    }

    private func showValidation(_ errors: [String]) {
        alertTitle = "Please fix the following"
        alertMessage = errors.enumerated().map { "• \($0.offset + 1). \($0.element)" }.joined(separator: "\n")
        showAlert = true
    }
}

@available(iOS 14.0, *)
struct AETheme {
    static let bgSoft = Color(UIColor.systemGroupedBackground)
    static let card = Color(UIColor.secondarySystemBackground)
    static let brand = Color.blue
    static let accentOrange = Color.orange
    static let textPrimary = Color.primary
}
