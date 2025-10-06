import SwiftUI

@available(iOS 14.0, *)
struct MaterialListRowView: View {
    let material: Material
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: MaterialTheme.categoryIcon(material.category))
                        .foregroundColor(MaterialTheme.accent)
                        .imageScale(.large)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(material.name)
                            .font(.headline)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Text(material.category)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    Spacer()
                    Text(material.availabilityStatus)
                        .font(.caption).bold()
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(MaterialTheme.statusColor(material.availabilityStatus))
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                }
                
                // Middle: Key metrics
                HStack(spacing: 16) {
                    metric(icon: "shippingbox.fill", title: "Qty", value: "\(material.quantity) \(material.unit)")
                    metric(icon: "dollarsign.circle.fill", title: "Unit", value: String(format: "%.2f %@", material.costPerUnit, material.currency))
                    metric(icon: MaterialTheme.qualityIcon(material.qualityStatus), title: "Quality", value: material.qualityStatus)
                }
                // Supplier / Brand / Location
                HStack(spacing: 12) {
                    pill(icon: "building.2.fill", text: material.supplier)
                    pill(icon: "tag.fill", text: material.brand)
                    pill(icon: "location.fill", text: material.storageLocation)
                }
                .lineLimit(1)
                
                // Tags
                if !material.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(material.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption).bold()
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(MaterialTheme.surface2)
                                    .clipShape(Capsule())
                                    .foregroundColor(MaterialTheme.textSecondary)
                            }
                        }
                    }
                }
                
                HStack {
                    label(icon: "number.circle.fill", text: material.referenceCode)
                    Spacer()
                    label(icon: "calendar.badge.clock", text: "Updated: \(Self.shortDate(material.updatedDate))")
                }
            }
        }
    }
    
    private func metric(icon: String, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon).foregroundColor(MaterialTheme.primary)
                Text(title).foregroundColor(Color.black).font(.caption)
            }
            Text(value).foregroundColor(Color.black).font(.subheadline).bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func pill(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(MaterialTheme.accent)
            Text(text).foregroundColor(MaterialTheme.textSecondary)
        }
        .font(.caption)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(MaterialTheme.surface2)
        .cornerRadius(8)
    }
    
    private func label(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(Color.black)
            Text(text).foregroundColor(Color.black).lineLimit(1)
        }
        .font(.caption)
    }
    
    private static func shortDate(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: d)
    }
}
