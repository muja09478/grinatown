import SwiftUI

@available(iOS 14.0, *)
struct MaterialDetailView: View {
    let material: Material
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                
                groupCard(title: "Overview", icon: "cube.box.fill") {
                    MaterialDetailFieldRow(icon: "textformat", title: "Name", value: material.name, accent: MaterialTheme.accent)
                    MaterialDetailFieldRow(icon: "square.grid.2x2.fill", title: "Category", value: material.category)
                    MaterialDetailFieldRow(icon: "bolt.horizontal.circle.fill", title: "Availability", value: material.availabilityStatus, accent: MaterialTheme.statusColor(material.availabilityStatus))
                    MaterialDetailFieldRow(icon: "number.circle", title: "Reference Code", value: material.referenceCode)
                    MaterialDetailFieldRow(icon: MaterialTheme.qualityIcon(material.qualityStatus), title: "Quality", value: material.qualityStatus)
                }
                
                groupCard(title: "Stock & Pricing", icon: "shippingbox.fill") {
                    MaterialDetailFieldRow(icon: "scalemass.fill", title: "Unit", value: material.unit)
                    MaterialDetailFieldRow(icon: "number", title: "Quantity", value: "\(material.quantity)")
                    MaterialDetailFieldRow(icon: "dollarsign.circle.fill", title: "Cost Per Unit", value: String(format: "%.2f %@", material.costPerUnit, material.currency))
                    MaterialDetailFieldRow(icon: "chart.line.uptrend.xyaxis", title: "Price History", value: material.unitPriceHistory.map { String(format: "%.2f", $0) }.joined(separator: ", "))
                }
                
                groupCard(title: "Logistics", icon: "building.2.fill") {
                    MaterialDetailFieldRow(icon: "building.2.fill", title: "Supplier", value: material.supplier)
                    MaterialDetailFieldRow(icon: "tag.fill", title: "Brand", value: material.brand)
                    MaterialDetailFieldRow(icon: "location.fill", title: "Storage Location", value: material.storageLocation)
                    MaterialDetailFieldRow(icon: "exclamationmark.triangle.fill", title: "Reorder Level", value: "\(material.reorderLevel)")
                    MaterialDetailFieldRow(icon: "arrow.down.circle.fill", title: "Reorder Quantity", value: "\(material.reorderQuantity)")
                    MaterialDetailFieldRow(icon: "barcode.viewfinder", title: "Batch Number", value: material.batchNumber)
                }
                
                groupCard(title: "Attributes", icon: "slider.horizontal.3") {
                    MaterialDetailFieldRow(icon: "drop.fill", title: "Color", value: material.color)
                    MaterialDetailFieldRow(icon: "square", title: "Size", value: material.size)
                    MaterialDetailFieldRow(icon: "scalemass", title: "Weight (kg)", value: String(format: "%.2f", material.weight))
                    MaterialDetailFieldRow(icon: "globe", title: "Origin", value: material.origin)
                    MaterialDetailFieldRow(icon: "doc.plaintext", title: "Compliance Certificate", value: material.complianceCertificate)
                    MaterialDetailFieldRow(icon: "note.text", title: "Notes", value: material.notes.isEmpty ? "—" : material.notes)
                }
                
                groupCard(title: "Dates", icon: "calendar") {
                    MaterialDetailFieldRow(icon: "calendar.badge.plus", title: "Purchase Date", value: dateStr(material.purchaseDate))
                    MaterialDetailFieldRow(icon: "calendar.circle", title: "Warranty Expiry", value: dateStr(material.warrantyExpiry))
                    MaterialDetailFieldRow(icon: "calendar.badge.exclamationmark", title: "Inspection Date", value: dateStr(material.inspectionDate))
                    MaterialDetailFieldRow(icon: "calendar", title: "Created Date", value: short(material.createdDate))
                    MaterialDetailFieldRow(icon: "calendar.badge.clock", title: "Updated Date", value: short(material.updatedDate))
                    MaterialDetailFieldRow(icon: "trash.circle.fill", title: "Disposal Date", value: dateStr(material.disposalDate))
                }
                
                groupCard(title: "Status & Meta", icon: "person.fill") {
                    MaterialDetailFieldRow(icon: "person.fill", title: "Last Modified By", value: material.lastModifiedBy)
                    MaterialDetailFieldRow(icon: "lock.circle.fill", title: "Reserved For Job", value: material.reservedForJob?.uuidString ?? "—")
                    MaterialDetailFieldRow(icon: "arrow.2.squarepath", title: "Recycled", value: material.recycled ? "Yes" : "No")
                    MaterialDetailFieldRow(icon: "archivebox.fill", title: "Archived", value: material.archived ? "Yes" : "No")
                    MaterialDetailFieldRow(icon: "coloncurrencysign.circle", title: "Currency", value: material.currency)
                    MaterialDetailFieldRow(icon: "tag.circle.fill", title: "Tags", value: material.tags.isEmpty ? "—" : material.tags.joined(separator: ", "))
                }
            }
            .padding()
        }
        .navigationBarTitle("Material Detail", displayMode: .inline)
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: MaterialTheme.categoryIcon(material.category))
                .foregroundColor(MaterialTheme.accent)
                .imageScale(.large)
            VStack(alignment: .leading, spacing: 4) {
                Text(material.name)
                    .font(.title3).bold()
                    .foregroundColor(.black)
                Text(material.category)
                    .foregroundColor(.black)
            }
            Spacer()
            Text(material.availabilityStatus)
                .font(.caption).bold()
                .padding(.horizontal, 8).padding(.vertical, 6)
                .background(MaterialTheme.statusColor(material.availabilityStatus))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 4)
    }
    
    private func groupCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(MaterialTheme.accent)
                Text(title).font(.headline).foregroundColor(.black)
            }
            .padding(.bottom, 4)
            VStack(alignment: .leading, spacing: 8, content: content)
                .padding()
                .background(MaterialTheme.surface2)
                .cornerRadius(14)
        }
        .padding(.horizontal, 4)
    }
    
    private func dateStr(_ d: Date?) -> String {
        guard let d = d else { return "—" }
        return short(d)
    }
    private func short(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: d)
    }
}
