import SwiftUI

@available(iOS 14.0, *)
struct ToolDetailView: View {
    let tool: Tool

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header

                groupCard(title: "Overview", icon: "wrench.fill", color: ToolTheme.brandBlue) {
                    twoColRow("Name", tool.name, "Category", tool.category)
                    twoColRow("Model", tool.model, "Brand", tool.brand)
                    twoColRow("Serial Number", tool.serialNumber, "Reference", tool.referenceCode)
                    ToolDetailFieldRow(icon: "text.bubble.fill", title: "Notes", value: tool.notes.isEmpty ? "—" : tool.notes)
                }

                groupCard(title: "Status & Assignment", icon: "person.crop.circle.fill", color: ToolTheme.accentTeal) {
                    twoColRow("Status", tool.status, "Condition", tool.condition)
                    twoColRow("Availability", tool.availabilityStatus, "Location", tool.location)
                    twoColRow("Assigned To", tool.assignedTo.isEmpty ? "—" : tool.assignedTo, "Supervisor", tool.supervisor)
                    twoColRow("Department", tool.department, "Archived", tool.archived ? "Yes" : "No")
                    ToolDetailFieldRow(icon: "tag.circle.fill", title: "Tags", value: tool.tags.isEmpty ? "—" : tool.tags.joined(separator: ", "))
                }

                groupCard(title: "Usage & Maintenance", icon: "gauge.with.dots", color: ToolTheme.accentOrange) {
                    twoColRow("Usage Hours", "\(tool.usageHours)", "Recycled", tool.recycled ? "Yes" : "No")
                    twoColRow("Maintenance", tool.maintenanceDate.short(), "Inspection", tool.inspectionDate.short())
                    twoColRow("Calibration", tool.calibrationDate.short(), "Warranty Expiry", tool.warrantyExpiry.short())
                    ToolDetailFieldRow(icon: "trash.fill", title: "Disposal Date", value: tool.disposalDate.short())
                }

                groupCard(title: "Financial", icon: "creditcard.fill", color: ToolTheme.brandBlue) {
                    twoColRow("Purchase Date", tool.purchaseDate.short(), "Currency", tool.currency)
                    twoColRow("Cost", Fmt.currency(tool.purchaseCost, code: tool.currency), "Depreciation %", Fmt.decimal(tool.depreciationRate, fraction: 1))
                    ToolDetailFieldRow(icon: "shippingbox.fill", title: "Supplier", value: tool.supplier.isEmpty ? "—" : tool.supplier)
                }

                groupCard(title: "Compliance & Insurance", icon: "checkmark.shield.fill", color: ToolTheme.accentTeal) {
                    twoColRow("Safety Cert.", tool.safetyCertificate.isEmpty ? "—" : tool.safetyCertificate,
                              "Insurance", tool.insuranceDetails.isEmpty ? "—" : tool.insuranceDetails)
                }

                groupCard(title: "Metadata", icon: "info.circle.fill", color: ToolTheme.accentOrange) {
                    ToolDetailFieldRow(icon: "calendar.badge.plus", title: "Created", value: tool.createdDate.short())
                    ToolDetailFieldRow(icon: "calendar.badge.clock", title: "Updated", value: tool.updatedDate.short())
                    ToolDetailFieldRow(icon: "link", title: "Reserved Job", value: tool.reservedForJob?.uuidString ?? "—")
                }
            }
            .padding(16)
        }
        .navigationBarTitle("Tool Details", displayMode: .inline)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(ToolTheme.brandBlue.opacity(0.12))
                    .frame(width: 64, height: 64)
                Image(systemName: "wrench.and.screwdriver.fill")
                    .foregroundColor(ToolTheme.brandBlue)
                    .font(.system(size: 26, weight: .bold))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(tool.name).font(.title3).bold().lineLimit(1)
                HStack(spacing: 8) {
                    Pill(title: tool.availabilityStatus, color: ToolTheme.accentTeal)
                    Pill(title: tool.status, color: ToolTheme.accentOrange)
                }
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibility(label: Text("\(tool.name) details"))
    }

    private func groupCard<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .bold))
                Text(title).font(.headline)
                Spacer()
            }
            content()
        }
        .padding(14)
        .toolCardStyle()
    }

    private func twoColRow(_ l1: String, _ v1: String, _ l2: String, _ v2: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ToolDetailFieldRow(icon: "square.grid.2x2", title: l1, value: v1)
                .frame(maxWidth: .infinity, alignment: .leading)
            ToolDetailFieldRow(icon: "square.grid.2x2.fill", title: l2, value: v2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

@available(iOS 14.0, *)
struct ToolDetailFieldRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(ToolTheme.brandBlue)
                .frame(width: 16)
            Text(title + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibility(label: Text("\(title) \(value)"))
    }
}
