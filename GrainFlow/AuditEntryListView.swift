import SwiftUI
import Combine

@available(iOS 14.0, *)
struct AuditEntryListView: View {
    @ObservedObject var store: CarpenterDataManager

    @State private var search = ""

    private var filtered: [AuditEntry] {
        guard !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return store.auditEntries }
        let q = search.lowercased()
        return store.auditEntries.filter { e in
            // Rich filtering across many fields
            return e.entityType.lowercased().contains(q)
                || e.action.lowercased().contains(q)
                || e.performedBy.lowercased().contains(q)
                || e.reason.lowercased().contains(q)
                || e.location.lowercased().contains(q)
                || e.ipAddress.lowercased().contains(q)
                || e.appVersion.lowercased().contains(q)
                || e.osVersion.lowercased().contains(q)
                || e.referenceCode.lowercased().contains(q)
                || e.approvalStatus.lowercased().contains(q)
                || e.severity.lowercased().contains(q)
                || e.complianceStatus.lowercased().contains(q)
                || e.tags.joined(separator: ",").lowercased().contains(q)
        }
    }

    var body: some View {
            ZStack {

                VStack(spacing: 8) {
                    AuditEntrySearchBarView(text: $search)

                    if filtered.isEmpty {
                        AuditEntryNoDataView()
                        Spacer()
                    } else {
                      
                        List {
                            ForEach(filtered) { entry in
                                NavigationLink(destination: AuditEntryDetailView(entry: entry)) {
                                    AuditEntryListRowView(entry: entry)
                                        .listRowInsets(EdgeInsets())
                                        .listRowBackground(Color.clear)
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationBarTitle("Audit Entries", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: AuditEntryAddView(store: store)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                       .accessibilityLabel("Add Audit Entry")
                }
            )
        
    }

    private func delete(at offsets: IndexSet) {
        var toDelete: [Int] = []
        for index in offsets {
            let item = filtered[index]
            if let sourceIndex = store.auditEntries.firstIndex(of: item) {
                toDelete.append(sourceIndex)
            }
        }
        store.auditEntries.remove(atOffsets: IndexSet(toDelete))
    }
}

