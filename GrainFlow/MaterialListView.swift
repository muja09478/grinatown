import SwiftUI

@available(iOS 14.0, *)
struct MaterialListView: View {
    @ObservedObject var manager: CarpenterDataManager
    @State private var query: String = ""
    @State private var showingAdd: Bool = false
    
    var filtered: [Material] {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return manager.materials }
        let q = query.lowercased()
        return manager.materials.filter { m in
            if m.name.lowercased().contains(q) { return true }
            if m.category.lowercased().contains(q) { return true }
            if m.supplier.lowercased().contains(q) { return true }
            if m.tags.joined(separator: " ").lowercased().contains(q) { return true }
            return false
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                MaterialSearchBarView(text: $query)
                
                if filtered.isEmpty {
                    noDataView
                        .padding(.top, 40)
                        .transition(.opacity)
                } else {
                    List {
                        ForEach(filtered) { m in
                            NavigationLink(destination: MaterialDetailView(material: m)) {
                                MaterialListRowView(material: m)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
        }
        .navigationBarTitle("Materials", displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: { showingAdd = true }) {
            HStack(spacing: 6) {
                Image(systemName: "plus.circle.fill")
                Text("Add")
            }
            .foregroundColor(MaterialTheme.accent)
            .accessibilityLabel("Add Material")
        }
        )
        .sheet(isPresented: $showingAdd) {
            NavigationView {
                MaterialAddView(manager: manager)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        let idsToDelete = offsets.map { filtered[$0].id }
        if var arr = Optional(manager.materials) {
            arr.removeAll { idsToDelete.contains($0.id) }
            manager.materials = arr
        }
    }
    
    private var noDataView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle().fill(MaterialTheme.surface).frame(width: 120, height: 120)
                Image(systemName: "shippingbox.and.arrow.backward.fill")
                    .resizable().scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(MaterialTheme.accent)
            }
            Text("No Materials Found")
                .font(.headline)
                .foregroundColor(MaterialTheme.textPrimary)
            Text("Try adjusting your search or add a new material.")
                .font(.subheadline)
                .foregroundColor(MaterialTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .accessibilityElement(children: .combine)
    }
}
