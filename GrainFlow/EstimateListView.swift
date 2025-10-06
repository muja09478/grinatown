import SwiftUI


@available(iOS 14.0, *)
struct EstimateListView: View {
    @ObservedObject var data: CarpenterDataManager
    
    @State private var searchText: String = ""
    @State private var isShowingAdd: Bool = false
    
    private func clientName(for id: UUID) -> String {
        data.clients.first(where: { $0.id == id })?.name ?? "Unknown Client"
    }
    private func jobCode(for id: UUID) -> String {
        data.jobListings.first(where: { $0.id == id })?.referenceCode ?? "N/A"
    }
    
    private var filtered: [Estimate] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return data.estimates
        }
        let q = searchText.lowercased()
        return data.estimates.filter { e in
            let c = clientName(for: e.clientID).lowercased()
            return e.referenceCode.lowercased().contains(q)
            || e.status.lowercased().contains(q)
            || c.contains(q)
            || e.approvalStatus.lowercased().contains(q)
            || e.preparedBy.lowercased().contains(q)
            || e.approvedBy.lowercased().contains(q)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            EstimateSearchBarView(text: $searchText)
            if filtered.isEmpty {
                EstimateNoDataView()
                Spacer()
            } else {
                List {
                    ForEach(filtered) { estimate in
                        NavigationLink(destination: EstimateDetailView(data: data, estimate: estimate)) {
                                EstimateListRowView(
                                    estimate: estimate,
                                    clientName: clientName(for: estimate.clientID),
                                    jobCode: jobCode(for: estimate.jobID)
                                )
                            }
                    }
                    .onDelete(perform: delete)
                }
            }
        }
        .navigationBarTitle("Estimates", displayMode: .inline)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: EstimateAddView(data: data)) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(EstimateTheme.primary)
                        .imageScale(.large)
                        .accessibilityLabel(Text("Add Estimate"))
                }
        )
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func delete(at offsets: IndexSet) {
        let idsToDelete = offsets.compactMap { filtered[$0].id }
        if !idsToDelete.isEmpty {
        }
    }
}
