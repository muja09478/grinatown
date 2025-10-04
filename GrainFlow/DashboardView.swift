import SwiftUI

@available(iOS 14.0, *)
struct DashboardView: View {
    @StateObject private var dataManager = CarpenterDataManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    ZStack(alignment: .leading) {
                        LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.8), .green.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 160)
                        .cornerRadius(24)
                        .shadow(radius: 6)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Carpenter Dashboard")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Your business at a glance")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            StatCardNew(
                                title: "Active Jobs",
                                value: "\(dataManager.jobListings.filter { $0.status == "Ongoing" }.count)",
                                icon: "hammer.fill",
                                gradient: [Color.blue, Color.purple]
                            )
                            
                            StatCardNew(
                                title: "Clients",
                                value: "\(dataManager.clients.count)",
                                icon: "person.2.fill",
                                gradient: [Color.green, Color.orange]
                            )
                            
                            StatCardNew(
                                title: "Estimates",
                                value: "\(dataManager.estimates.filter { $0.status == "Draft" }.count)",
                                icon: "doc.text.fill",
                                gradient: [Color.orange, Color.red]
                            )
                            
                            StatCardNew(
                                title: "Tools",
                                value: "\(dataManager.tools.filter { $0.status == "Good" }.count)",
                                icon: "wrench.and.screwdriver.fill",
                                gradient: [Color.purple, Color.green]
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 16) {
                        NavigationGridItem(
                            title: "Jobs",
                            subtitle: "Manage job listings",
                            icon: "list.bullet.clipboard.fill",
                            color: .blue,
                            destination: AnyView(JobListingListView(manager: dataManager))
                        )
                        
                        NavigationGridItem(
                            title: "Clients",
                            subtitle: "Client management",
                            icon: "person.2.fill",
                            color: .green,
                            destination: AnyView(ClientListView(data: dataManager))
                        )
                        
                        NavigationGridItem(
                            title: "Estimates",
                            subtitle: "Cost estimates",
                            icon: "doc.text.fill",
                            color: .orange,
                            destination: AnyView(EstimateListView(data: dataManager))
                        )
                        
                        NavigationGridItem(
                            title: "Materials",
                            subtitle: "Track inventory",
                            icon: "cube.box.fill",
                            color: .red,
                            destination: AnyView(MaterialListView(manager: dataManager))
                        )
                        
                        NavigationGridItem(
                            title: "Tools",
                            subtitle: "Tool management",
                            icon: "wrench.fill",
                            color: .purple,
                            destination: AnyView(ToolListView(dataManager: dataManager))
                        )
                        
                        NavigationGridItem(
                            title: "Audit Log",
                            subtitle: "Activity tracking",
                            icon: "clock.arrow.circlepath",
                            color: .red,
                            destination: AnyView(AuditEntryListView(store: dataManager))
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
        }
    }
}

@available(iOS 14.0, *)
struct StatCardNew: View {
    let title: String
    let value: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .frame(width: 160, height: 100)
        .background(
            LinearGradient(gradient: Gradient(colors: gradient),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

@available(iOS 14.0, *)
struct NavigationGridItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

