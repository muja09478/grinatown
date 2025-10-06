import SwiftUI

@available(iOS 14.0, *)
struct ToolListView: View {
    @ObservedObject var dataManager: CarpenterDataManager
    @State private var searchText: String = ""
    @State private var showAdd: Bool = false

    private var filtered: [Tool] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return dataManager.tools }
        return dataManager.tools.filter { tool in
            let haystack = [
                tool.name, tool.category, tool.serialNumber, tool.model, tool.brand,
                tool.status, tool.location, tool.assignedTo, tool.condition,
                tool.referenceCode, tool.supplier, tool.safetyCertificate,
                tool.insuranceDetails, tool.supervisor, tool.department,
                tool.availabilityStatus, tool.currency
            ] + tool.tags
            return haystack.joined(separator: " ").lowercased().contains(q)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ToolSearchBarView(text: $searchText)
                .padding(.horizontal)
                .padding(.top, 12)

            if filtered.isEmpty {
                Spacer()
                ToolNoDataView()
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(filtered) { tool in
                        NavigationLink(destination: ToolDetailView(tool: tool)) {
                            ToolListRowView(tool: tool)
                                .padding(.vertical, 6)
                                .accessibilityElement(children: .combine)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarTitle("Tools", displayMode: .large)
        .navigationBarItems(trailing:
            Button(action: { showAdd = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(ToolTheme.brandBlue)
                    .accessibility(label: Text("Add Tool"))
            }
        )
        .sheet(isPresented: $showAdd) {
            NavigationView {
                ToolAddView(dataManager: dataManager ) { newTool in
                    dataManager.addTool(newTool)
                }
                .environmentObject(dataManager)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let toDeleteIDs = offsets.map { filtered[$0].id }
        if let indexSet = IndexSet(dataManager.tools.enumerated().compactMap { toDeleteIDs.contains($0.element.id) ? $0.offset : nil }) as IndexSet? {
            dataManager.deleteTool(at: indexSet)
        }
    }
}


@available(iOS 14.0, *)
struct ToolSearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ToolTheme.brandBlue)
                TextField("Search tools by name, serial, status…", text: $text, onEditingChanged: { editing in
                    withAnimation(.easeInOut(duration: 0.2)) { isEditing = editing }
                })
                .textContentType(.none)
                .autocapitalization(.none)
                .disableAutocorrection(true)

                if !text.isEmpty {
                    Button(action: {
                        withAnimation(.spring()) { text = "" }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .accessibility(label: Text("Clear search"))
                }
            }
            .padding(10)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ToolTheme.brandBlue.opacity(0.25), lineWidth: 1)
            )
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(isEditing ? 0.08 : 0.03), radius: isEditing ? 8 : 4, x: 0, y: isEditing ? 6 : 3)

            if isEditing {
                Button("Cancel") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isEditing = false
                    }
                }
                .foregroundColor(ToolTheme.accentTeal)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .accessibilityElement(children: .contain)
    }
}

@available(iOS 14.0, *)
struct ToolNoDataView: View {
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(ToolTheme.chipBg)
                    .frame(width: 96, height: 96)
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(ToolTheme.brandBlue)
            }
            Text("No Tools Found")
                .font(.headline)
            Text("Add your first tool with the + button. Organize, track usage, and keep maintenance on schedule.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .accessibilityElement(children: .combine)
    }
}

@available(iOS 14.0, *)
struct ToolListRowView: View {
    let tool: Tool

    private var statusColor: Color {
        switch tool.availabilityStatus.lowercased() {
        case "available": return ToolTheme.accentTeal
        case "reserved": return ToolTheme.accentOrange
        default: return ToolTheme.brandBlue
        }
    }

    var body: some View {
        VStack( spacing: 12) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .firstTextBaseline) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ToolTheme.brandBlue.opacity(0.12))
                            .frame(width: 56, height: 56)
                        Image(systemName: "wrench.fill")
                            .foregroundColor(ToolTheme.brandBlue)
                            .font(.system(size: 22, weight: .semibold))
                    }
                    
                    Text(tool.name)
                        .font(.headline)
                        .foregroundColor(ToolTheme.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    Pill(title: tool.availabilityStatus, color: statusColor)
                }

                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        chip(icon: "barcode.viewfinder", text: tool.serialNumber)
                        chip(icon: "tag.fill", text: tool.category)
                    }
                    HStack(spacing: 12) {
                        chip(icon: "wrench.and.screwdriver.fill", text: tool.model)
                        chip(icon: "building.2.fill", text: tool.brand)
                    }
                }

                VStack(spacing: 6) {
                    VStack {
                        labeled(icon: "clock.badge.checkmark", title: "Maint.", value: tool.maintenanceDate.short())
                        labeled(icon: "calendar", title: "Purchase", value: tool.purchaseDate.short())
                    }
                    HStack {
                        labeled(icon: "bolt.fill", title: "Usage Hrs", value: "\(tool.usageHours)")
                        labeled(icon: "creditcard.fill", title: "Cost", value: Fmt.currency(tool.purchaseCost, code: tool.currency))
                    }
                }

                HStack(spacing: 12) {
                    chip(icon: "location.fill", text: tool.location)
                    chip(icon: "person.fill", text: tool.assignedTo)
                    chip(icon: "shield.lefthalf.fill", text: tool.condition)
                }
            }
        }
        .padding(12)
        .toolCardStyle()
        .accessibilityElement(children: .combine)
        .accessibility(label: Text("\(tool.name), \(tool.brand) \(tool.model), status \(tool.availabilityStatus)"))
    }

    private func chip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(ToolTheme.brandBlue)
            Text(text).font(.caption).foregroundColor(.secondary).lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(ToolTheme.chipBg)
        .clipShape(Capsule())
        .accessibilityElement(children: .combine)
    }

    private func labeled(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(ToolTheme.accentOrange)
            Text(title + ":").font(.caption).foregroundColor(.secondary)
            Text(value).font(.caption).foregroundColor(.primary).lineLimit(2)
            Spacer()
        }
//        .accessibilityElement(children: .combine)
    }
}

enum Fmt {
    static let number: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 0
        return nf
    }()
    static func decimal(_ value: Double, fraction: Int = 2) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = fraction
        nf.minimumFractionDigits = fraction
        return nf.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    static func currency(_ value: Double, code: String) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencyCode = code
        return nf.string(from: NSNumber(value: value)) ?? "\(code) \(value)"
    }
}

extension Optional where Wrapped == Date {
    func short() -> String {
        guard let d = self else { return "—" }
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: d)
    }
}

extension Date {
    func short() -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: self)
    }
}
