
import SwiftUI

@available(iOS 14.0, *)
struct JobListingListView: View {
    @ObservedObject var manager: CarpenterDataManager

    @State private var searchText: String = ""
    @State private var showAdd: Bool = false

    private var filteredJobs: [JobListing] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return manager.jobListings
        }
        let s = searchText.lowercased()
        return manager.jobListings.filter { j in
            j.title.lowercased().contains(s)
            || j.description.lowercased().contains(s)
            || j.location.lowercased().contains(s)
            || j.status.lowercased().contains(s)
            || j.tags.joined(separator: " ").lowercased().contains(s)
            || j.category.lowercased().contains(s)
            || j.referenceCode.lowercased().contains(s)
        }
    }

    var body: some View {
            VStack(spacing: 12) {
                JobListingSearchBarView(text: $searchText)
                    .padding(.horizontal)

                if filteredJobs.isEmpty {
                    JobListingNoDataView()
                } else {
                    List {
                        ForEach(filteredJobs) { job in
                              NavigationLink(
                                destination: JobListingDetailView(manager: manager, job: job)){
                                    JobListingListRowView(job: job, clientName: manager.clientName(for: job.clientID))
                                        .padding(.vertical, 6)
                                }
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: manager.deleteJobListing)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Jobs", displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: { showAdd = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.blue)
                        .accessibilityLabel(Text("Add Job"))
                }
            )
        
        .sheet(isPresented: $showAdd) {
            NavigationView {
                JobListingAddView { newJob in
                    manager.addJobListing(newJob)
                    showAdd = false
                }
                .environmentObject(manager)
            }
        }
    }
}
