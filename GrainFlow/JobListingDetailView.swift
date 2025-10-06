import SwiftUI

@available(iOS 14.0, *)
struct JobListingDetailView: View {
    @ObservedObject var manager: CarpenterDataManager
    let job: JobListing

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header

                groupCard(title: "Overview", icon: "info.circle.fill") {
                    twoCol {
                        JobListingDetailFieldRow(icon: "person.fill", title: "Client", value: manager.clientName(for: job.clientID))
                        JobListingDetailFieldRow(icon: "mappin.and.ellipse", title: "Location", value: job.location)
                        JobListingDetailFieldRow(icon: "tag.fill", title: "Category", value: job.category)
                        JobListingDetailFieldRow(icon: "bolt.horizontal.fill", title: "Priority", value: job.priority)
                        JobListingDetailFieldRow(icon: "number", title: "Reference", value: job.referenceCode)
                        JobListingDetailFieldRow(icon: "doc.text.fill", title: "Invoice", value: job.invoiceNumber)
                    }
                    JobListingDetailFieldRow(icon: "text.alignleft", title: "Description", value: job.description)
                }

                groupCard(title: "Schedule", icon: "calendar.badge.clock") {
                    twoCol {
                        JobListingDetailFieldRow(icon: "calendar", title: "Start", value: dateText(job.startDate))
                        JobListingDetailFieldRow(icon: "calendar", title: "End", value: dateText(job.endDate))
                        JobListingDetailFieldRow(icon: "clock.badge.checkmark", title: "Estimated Hours", value: "\(job.estimatedHours)")
                        JobListingDetailFieldRow(icon: "clock.fill", title: "Actual Hours", value: "\(job.actualHours)")
                        JobListingDetailFieldRow(icon: "person.badge.shield.checkmark", title: "Approval", value: job.approvalStatus)
                        JobListingDetailFieldRow(icon: "pencil.and.outline", title: "Revisions", value: "\(job.revisionCount)")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Progress").font(.caption).foregroundColor(.secondary)
                        ProgressView(value: Float(job.progress) / 100.0)
                        Text("\(job.progress)%").font(.caption).foregroundColor(.secondary)
                    }
                }

                groupCard(title: "Financials", icon: "dollarsign.circle.fill") {
                    twoCol {
                        JobListingDetailFieldRow(icon: "dollarsign.circle.fill", title: "Budget", value: money(job.budget, job.currency), color: .green)
                        JobListingDetailFieldRow(icon: "creditcard.fill", title: "Payment", value: job.paymentStatus)
                        JobListingDetailFieldRow(icon: "percent", title: "Discount", value: "\(job.discountOffered)%")
                        JobListingDetailFieldRow(icon: "percent", title: "Tax Rate", value: "\(job.taxRate)%")
                        JobListingDetailFieldRow(icon: "coloncurrencysign.circle", title: "Currency", value: job.currency)
                        JobListingDetailFieldRow(icon: "checkmark.seal", title: "Warranty", value: job.warrantyPeriod)
                    }
                }

                groupCard(title: "Quality & Safety", icon: "shield.lefthalf.fill") {
                    twoCol {
                        JobListingDetailFieldRow(icon: "checkmark.seal.fill", title: "Quality", value: job.qualityCheckStatus, color: .green)
                        JobListingDetailFieldRow(icon: "doc.text.magnifyingglass", title: "Contract", value: job.contractTerms)
                        JobListingDetailFieldRow(icon: "lock.shield", title: "Certificate", value: job.completionCertificate ? "Yes" : "No")
                        JobListingDetailFieldRow(icon: "exclamationmark.triangle.fill", title: "Safety Notes", value: job.safetyNotes)
                    }
                }

                groupCard(title: "People & Tags", icon: "person.3.fill") {
                    JobListingDetailFieldRow(icon: "person.crop.square", title: "Supervisor", value: job.supervisor)
                    JobListingDetailFieldRow(icon: "building.2.crop.circle", title: "Department", value: job.department)
                    Text("Assigned Carpenters").font(.caption).foregroundColor(.secondary)
                    JobListingChipsView(items: job.assignedCarpenters, color: .blue)
                    Text("Tags").font(.caption).foregroundColor(.secondary).padding(.top, 8)
                    JobListingChipsView(items: job.tags, color: .orange)
                }

                groupCard(title: "Meta", icon: "gearshape.fill") {
                    twoCol {
                        JobListingDetailFieldRow(icon: "calendar.badge.plus", title: "Created", value: df.string(from: job.createdDate))
                        JobListingDetailFieldRow(icon: "calendar.badge.exclamationmark", title: "Updated", value: df.string(from: job.updatedDate))
                        JobListingDetailFieldRow(icon: "person.fill", title: "Last Modified By", value: job.lastModifiedBy)
                        JobListingDetailFieldRow(icon: "archivebox.fill", title: "Archived", value: job.archived ? "Yes" : "No")
                        JobListingDetailFieldRow(icon: "note.text", title: "Notes", value: job.notes)
                        JobListingDetailFieldRow(icon: "hammer.fill", title: "Status", value: job.status)
                    }
                }

                Spacer(minLength: 24)
            }
            .padding(16)
        }
        .navigationBarTitle("Job Details", displayMode: .inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue,.green]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.title).font(.title3).bold().foregroundColor(.primary)
                    Text(manager.clientName(for: job.clientID)).font(.subheadline).foregroundColor(.secondary)
                }
                Spacer()
                Text(job.status)
                    .font(.caption).bold()
                    .padding(.vertical, 6).padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
            }
            Text(job.description).font(.subheadline).foregroundColor(.primary)
        }
    }

    private func groupCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon).foregroundColor(.blue).accessibilityHidden(true)
                Text(title).font(.headline)
                Spacer()
            }
            content()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.green)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }

    private func twoCol<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 10, content: content)
    }

    private func dateText(_ d: Date?) -> String { d.map { df.string(from: $0) } ?? "—" }
    private func money(_ v: Double, _ c: String) -> String { "\(c) \(String(format: "%.2f", v))" }
    private var df: DateFormatter { let f = DateFormatter(); f.dateStyle = .medium; return f }
}
