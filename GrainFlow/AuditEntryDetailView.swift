import SwiftUI

@available(iOS 14.0, *)
struct AuditEntryDetailView: View {
    let entry: AuditEntry

    private let twoCols = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard

                sectionCard(title: "Overview", icon: "info.circle.fill") {
                    LazyVGrid(columns: twoCols, spacing: 12) {
                        AuditEntryDetailFieldRow(icon: "cube.box.fill", title: "Entity Type", value: entry.entityType)
                        AuditEntryDetailFieldRow(icon: "number.circle", title: "Entity ID", value: entry.entityID.uuidString)
                        AuditEntryDetailFieldRow(icon: "bolt.fill", title: "Action", value: entry.action)
                        AuditEntryDetailFieldRow(icon: "person.crop.circle", title: "Performed By", value: entry.performedBy)
                        AuditEntryDetailFieldRow(icon: "barcode.viewfinder", title: "Reference", value: entry.referenceCode)
                    }
                }

                sectionCard(title: "Values & Reason", icon: "doc.plaintext") {
                    AuditEntryDetailFieldRow(icon: "text.badge.checkmark", title: "Reason", value: entry.reason)
                    AuditEntryDetailFieldRow(icon: "arrow.uturn.backward.circle.fill", title: "Old Value", value: entry.oldValue)
                    AuditEntryDetailFieldRow(icon: "arrow.uturn.forward.circle.fill", title: "New Value", value: entry.newValue)
                }

                sectionCard(title: "Environment", icon: "desktopcomputer") {
                    LazyVGrid(columns: twoCols, spacing: 12) {
                        AuditEntryDetailFieldRow(icon: "iphone", title: "Device", value: entry.device)
                        AuditEntryDetailFieldRow(icon: "network", title: "IP Address", value: entry.ipAddress)
                        AuditEntryDetailFieldRow(icon: "mappin.and.ellipse", title: "Location", value: entry.location)
                        AuditEntryDetailFieldRow(icon: "rectangle.badge.person.crop", title: "Session ID", value: entry.sessionID)
                        AuditEntryDetailFieldRow(icon: "app.badge.fill", title: "App Version", value: entry.appVersion)
                        AuditEntryDetailFieldRow(icon: "gearshape.2.fill", title: "OS Version", value: entry.osVersion)
                    }
                }

                sectionCard(title: "Status & Compliance", icon: "checkmark.seal.fill") {
                    LazyVGrid(columns: twoCols, spacing: 12) {
                        AuditEntryDetailFieldRow(icon: "exclamationmark.triangle.fill", title: "Severity", value: entry.severity)
                        AuditEntryDetailFieldRow(icon: "checkmark.circle.fill", title: "Compliance", value: entry.complianceStatus)
                        AuditEntryDetailFieldRow(icon: "checkmark.shield.fill", title: "Approval Status", value: entry.approvalStatus)
                        AuditEntryDetailFieldRow(icon: "signature", title: "Approved By", value: entry.approvedBy)
                        AuditEntryDetailFieldRow(icon: "xmark.seal.fill", title: "Rejection Reason", value: entry.rejectionReason)
                        AuditEntryDetailFieldRow(icon: "calendar.badge.plus", title: "Follow-up", value: entry.followUpDate?.aeFormatted() ?? "—")
                    }
                }

                sectionCard(title: "Organization", icon: "building.2.fill") {
                    LazyVGrid(columns: twoCols, spacing: 12) {
                        AuditEntryDetailFieldRow(icon: "person.2.badge.gearshape.fill", title: "Supervisor", value: entry.supervisor)
                        AuditEntryDetailFieldRow(icon: "list.bullet.rectangle.portrait.fill", title: "Department", value: entry.department)
                        AuditEntryDetailFieldRow(icon: "archivebox.fill", title: "Archived", value: entry.archived ? "Yes" : "No")
                        AuditEntryDetailFieldRow(icon: "calendar.badge.exclamationmark", title: "Created", value: entry.createdDate.aeFormatted())
                        AuditEntryDetailFieldRow(icon: "calendar.badge.clock", title: "Updated", value: entry.updatedDate.aeFormatted())
                    }
                }

                sectionCard(title: "Relations", icon: "link") {
                    AuditEntryDetailFieldRow(icon: "wrench.and.screwdriver.fill", title: "Job ID", value: entry.relatedJobID?.uuidString ?? "")
                    AuditEntryDetailFieldRow(icon: "person.3.fill", title: "Client ID", value: entry.relatedClientID?.uuidString ?? "")
                    AuditEntryDetailFieldRow(icon: "hammer.fill", title: "Tool ID", value: entry.relatedToolID?.uuidString ?? "")
                    AuditEntryDetailFieldRow(icon: "shippingbox.fill", title: "Material ID", value: entry.relatedMaterialID?.uuidString ?? "")
                }

                sectionCard(title: "Tags & Notes", icon: "tag.fill") {
                    if !entry.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(entry.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.08))
                                        .foregroundColor(AETheme.brand)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    AuditEntryDetailFieldRow(icon: "note.text", title: "Notes", value: entry.notes)
                }
            }
            .padding(.vertical, 12)
        }
        .background(AETheme.bgSoft.ignoresSafeArea())
        .navigationBarTitle("Audit Detail", displayMode: .inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(entry.entityType, systemImage: "cube.box.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(entry.timestamp.aeFormatted())
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            HStack(spacing: 10) {
                chip("bolt.fill", entry.action, AETheme.card.opacity(0.15), .white)
                chip("exclamationmark.triangle.fill", entry.severity, AETheme.card.opacity(0.15), .white)
                chip("checkmark.seal.fill", entry.approvalStatus, AETheme.card.opacity(0.15), .white)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AETheme.brand)
        .cornerRadius(16)
        .padding(.horizontal)
        .shadow(color: AETheme.brand.opacity(0.3), radius: 12, x: 0, y: 8)
        .accessibilityElement(children: .combine)
    }

    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(AETheme.brand)
                Text(title)
                    .font(.headline)
            }
            content()
        }
        .padding(16)
        .background(AETheme.card)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
        .padding(.horizontal)
    }

    private func chip(_ icon: String, _ text: String, _ bg: Color, _ fg: Color) -> some View {
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
}


extension Date {
    func aeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short    
        return formatter.string(from: self)
    }
}
