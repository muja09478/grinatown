import Foundation
import SwiftUI

// MARK: - Job Listing
struct JobListing: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var clientID: UUID
    var startDate: Date?
    var endDate: Date?
    var status: String
    var budget: Double
    var location: String
    var priority: String
    var category: String
    var assignedCarpenters: [String]
    var progress: Int
    var notes: String
    var referenceCode: String
    var createdDate: Date
    var updatedDate: Date
    var estimatedHours: Int
    var actualHours: Int
    var paymentStatus: String
    var invoiceNumber: String
    var warrantyPeriod: String
    var completionCertificate: Bool
    var qualityCheckStatus: String
    var safetyNotes: String
    var contractTerms: String
    var discountOffered: Double
    var taxRate: Double
    var currency: String
    var revisionCount: Int
    var approvalStatus: String
    var supervisor: String
    var department: String
    var tags: [String]
    var lastModifiedBy: String
    var archived: Bool
}

// MARK: - Client
struct Client: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var contactNumber: String
    var email: String
    var address: String
    var company: String
    var preferredPaymentMethod: String
    var clientType: String
    var notes: String
    var createdDate: Date
    var updatedDate: Date
    var loyaltyLevel: String
    var totalJobs: Int
    var completedJobs: Int
    var pendingJobs: Int
    var cancelledJobs: Int
    var outstandingBalance: Double
    var lastPaymentDate: Date?
    var preferredContactTime: String
    var referenceCode: String
    var rating: Int
    var feedback: String
    var taxID: String
    var billingAddress: String
    var shippingAddress: String
    var alternatePhone: String
    var emergencyContact: String
    var socialMediaHandle: String
    var preferredLanguage: String
    var region: String
    var zipCode: String
    var vip: Bool
    var accountManager: String
    var tags: [String]
    var archived: Bool
}

// MARK: - Estimate
struct Estimate: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var jobID: UUID
    var clientID: UUID
    var issueDate: Date
    var validUntil: Date
    var status: String
    var totalCost: Double
    var laborCost: Double
    var materialCost: Double
    var toolCost: Double
    var taxAmount: Double
    var discount: Double
    var grandTotal: Double
    var notes: String
    var currency: String
    var version: Int
    var referenceCode: String
    var preparedBy: String
    var approvedBy: String
    var approvalStatus: String
    var createdDate: Date
    var updatedDate: Date
    var revisionNotes: String
    var validityPeriod: Int
    var paymentTerms: String
    var warrantyTerms: String
    var deliverySchedule: String
    var riskAssessment: String
    var complianceNotes: String
    var legalClauses: String
    var insuranceDetails: String
    var specialDiscountReason: String
    var extraCharges: Double
    var supervisor: String
    var tags: [String]
    var archived: Bool
}

// MARK: - Material
struct Material: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var category: String
    var unit: String
    var quantity: Int
    var costPerUnit: Double
    var supplier: String
    var brand: String
    var purchaseDate: Date?
    var warrantyExpiry: Date?
    var storageLocation: String
    var reorderLevel: Int
    var reorderQuantity: Int
    var batchNumber: String
    var referenceCode: String
    var qualityStatus: String
    var inspectionDate: Date?
    var createdDate: Date
    var updatedDate: Date
    var color: String
    var size: String
    var weight: Double
    var origin: String
    var complianceCertificate: String
    var notes: String
    var tags: [String]
    var lastModifiedBy: String
    var reservedForJob: UUID?
    var availabilityStatus: String
    var disposalDate: Date?
    var recycled: Bool
    var unitPriceHistory: [Double]
    var currency: String
    var archived: Bool
}

// MARK: - Tool
struct Tool: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var category: String
    var serialNumber: String
    var model: String
    var brand: String
    var purchaseDate: Date?
    var warrantyExpiry: Date?
    var status: String
    var location: String
    var assignedTo: String
    var maintenanceDate: Date?
    var condition: String
    var usageHours: Int
    var referenceCode: String
    var notes: String
    var createdDate: Date
    var updatedDate: Date
    var purchaseCost: Double
    var supplier: String
    var inspectionDate: Date?
    var calibrationDate: Date?
    var safetyCertificate: String
    var insuranceDetails: String
    var tags: [String]
    var supervisor: String
    var department: String
    var availabilityStatus: String
    var reservedForJob: UUID?
    var disposalDate: Date?
    var recycled: Bool
    var depreciationRate: Double
    var currency: String
    var archived: Bool
}

// MARK: - Audit Entry
struct AuditEntry: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var entityType: String
    var entityID: UUID
    var action: String
    var performedBy: String
    var timestamp: Date
    var reason: String
    var oldValue: String
    var newValue: String
    var device: String
    var ipAddress: String
    var location: String
    var sessionID: String
    var appVersion: String
    var osVersion: String
    var referenceCode: String
    var createdDate: Date
    var updatedDate: Date
    var approvalStatus: String
    var approvedBy: String
    var rejectionReason: String
    var tags: [String]
    var relatedJobID: UUID?
    var relatedClientID: UUID?
    var relatedToolID: UUID?
    var relatedMaterialID: UUID?
    var supervisor: String
    var department: String
    var archived: Bool
    var notes: String
    var severity: String
    var complianceStatus: String
    var correctiveAction: String
    var followUpDate: Date?
}
import Foundation
import Combine

// MARK: - Data Manager
class CarpenterDataManager: ObservableObject {
    // Published arrays
    @Published var jobListings: [JobListing] = []
    @Published var clients: [Client] = []
    @Published var estimates: [Estimate] = []
    @Published var materials: [Material] = []
    @Published var tools: [Tool] = []
    @Published var auditEntries: [AuditEntry] = []
    
    // Storage keys
    private let jobKey = "jobListings"
    private let clientKey = "clients"
    private let estimateKey = "estimates"
    private let materialKey = "materials"
    private let toolKey = "tools"
    private let auditKey = "auditEntries"
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Init
    init() {
        loadAll()
        // Load dummy data if empty
        if jobListings.isEmpty && clients.isEmpty {
            loadDummyData()
        }
    }
    
    // MARK: - Save All
    private func saveAll() {
        save(jobListings, forKey: jobKey)
        save(clients, forKey: clientKey)
        save(estimates, forKey: estimateKey)
        save(materials, forKey: materialKey)
        save(tools, forKey: toolKey)
        save(auditEntries, forKey: auditKey)
    }
    
    private func save<T: Codable>(_ data: [T], forKey key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    private func load<T: Codable>(forKey key: String, as type: T.Type) -> [T] {
        if let savedData = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode([T].self, from: savedData) {
            return decoded
        }
        return []
    }
    
    private func loadAll() {
        jobListings = load(forKey: jobKey, as: JobListing.self)
        clients = load(forKey: clientKey, as: Client.self)
        estimates = load(forKey: estimateKey, as: Estimate.self)
        materials = load(forKey: materialKey, as: Material.self)
        tools = load(forKey: toolKey, as: Tool.self)
        auditEntries = load(forKey: auditKey, as: AuditEntry.self)
    }
    
    // MARK: - Add Functions
    func addJobListing(_ job: JobListing) {
        jobListings.append(job)
        saveAll()
    }
    
    func addClient(_ client: Client) {
        clients.append(client)
        saveAll()
    }
    
    func addEstimate(_ estimate: Estimate) {
        estimates.append(estimate)
        saveAll()
    }
    
    func addMaterial(_ material: Material) {
        materials.append(material)
        saveAll()
    }
    
    func addTool(_ tool: Tool) {
        tools.append(tool)
        saveAll()
    }
    
    func addAuditEntry(_ entry: AuditEntry) {
        auditEntries.append(entry)
        saveAll()
    }
    
    // MARK: - Delete Functions
    func deleteJobListing(at offsets: IndexSet) {
        jobListings.remove(atOffsets: offsets)
        saveAll()
    }
    
    func deleteClient(at offsets: IndexSet) {
        clients.remove(atOffsets: offsets)
        saveAll()
    }
    
    func deleteEstimate(at offsets: IndexSet) {
        estimates.remove(atOffsets: offsets)
        saveAll()
    }
    
    func deleteMaterial(at offsets: IndexSet) {
        materials.remove(atOffsets: offsets)
        saveAll()
    }
    
    func deleteTool(at offsets: IndexSet) {
        tools.remove(atOffsets: offsets)
        saveAll()
    }
    
    func deleteAuditEntry(at offsets: IndexSet) {
        auditEntries.remove(atOffsets: offsets)
        saveAll()
    }
    
    func clientName(for id: UUID) -> String {
        clients.first(where: { $0.id == id })?.name ?? "Unknown Client"
    }
    
    // MARK: - Dummy Data
    private func loadDummyData() {
        clients = (1...5).map { i in
            Client(
                name: "Client \(i)",
                contactNumber: "123-456-789\(i)",
                email: "client\(i)@mail.com",
                address: "Street \(i), City",
                company: "Company \(i)",
                preferredPaymentMethod: "Cash",
                clientType: "Regular",
                notes: "Important client",
                createdDate: Date(),
                updatedDate: Date(),
                loyaltyLevel: "Gold",
                totalJobs: 10,
                completedJobs: 8,
                pendingJobs: 2,
                cancelledJobs: 0,
                outstandingBalance: Double(i) * 1000,
                lastPaymentDate: Date(),
                preferredContactTime: "Morning",
                referenceCode: "CL\(i)",
                rating: 5,
                feedback: "Great service",
                taxID: "TAX\(i)",
                billingAddress: "Billing Address \(i)",
                shippingAddress: "Shipping Address \(i)",
                alternatePhone: "987-654-321\(i)",
                emergencyContact: "Emergency \(i)",
                socialMediaHandle: "@client\(i)",
                preferredLanguage: "English",
                region: "Region \(i)",
                zipCode: "ZIP\(i)",
                vip: i % 2 == 0,
                accountManager: "Manager \(i)",
                tags: ["Loyal", "Priority"],
                archived: false
            )
        }
        
        jobListings = (1...10).map { i in
            JobListing(
                title: "Job \(i)",
                description: "Carpentry job \(i)",
                clientID: clients.randomElement()!.id,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: i, to: Date()),
                status: "Ongoing",
                budget: Double(i) * 500,
                location: "Workshop \(i)",
                priority: "High",
                category: "Furniture",
                assignedCarpenters: ["Worker A", "Worker B"],
                progress: i * 10,
                notes: "Handle with care",
                referenceCode: "JOB\(i)",
                createdDate: Date(),
                updatedDate: Date(),
                estimatedHours: 40,
                actualHours: 20,
                paymentStatus: "Pending",
                invoiceNumber: "INV\(i)",
                warrantyPeriod: "12 months",
                completionCertificate: false,
                qualityCheckStatus: "Passed",
                safetyNotes: "Wear gloves",
                contractTerms: "Standard",
                discountOffered: 5.0,
                taxRate: 10.0,
                currency: "USD",
                revisionCount: 0,
                approvalStatus: "Approved",
                supervisor: "Supervisor \(i)",
                department: "Dept \(i)",
                tags: ["Wood", "Custom"],
                lastModifiedBy: "Admin",
                archived: false
            )
        }
        
        materials = (1...10).map { i in
            Material(
                name: "Material \(i)",
                category: "Wood",
                unit: "Piece",
                quantity: i * 5,
                costPerUnit: Double(i) * 20,
                supplier: "Supplier \(i)",
                brand: "Brand \(i)",
                purchaseDate: Date(),
                warrantyExpiry: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
                storageLocation: "Warehouse \(i)",
                reorderLevel: 5,
                reorderQuantity: 10,
                batchNumber: "BATCH\(i)",
                referenceCode: "MAT\(i)",
                qualityStatus: "Good",
                inspectionDate: Date(),
                createdDate: Date(),
                updatedDate: Date(),
                color: "Brown",
                size: "M",
                weight: Double(i) * 2,
                origin: "Country \(i)",
                complianceCertificate: "Cert\(i)",
                notes: "Keep dry",
                tags: ["Stock"],
                lastModifiedBy: "System",
                reservedForJob: nil,
                availabilityStatus: "Available",
                disposalDate: nil,
                recycled: false,
                unitPriceHistory: [10.0, 20.0],
                currency: "USD",
                archived: false
            )
        }
        
        tools = (1...8).map { i in
            Tool(
                name: "Tool \(i)",
                category: "Hand Tool",
                serialNumber: "SN\(i)",
                model: "Model \(i)",
                brand: "Brand \(i)",
                purchaseDate: Date(),
                warrantyExpiry: Calendar.current.date(byAdding: .year, value: 2, to: Date()),
                status: "Good",
                location: "Shelf \(i)",
                assignedTo: "Worker \(i)",
                maintenanceDate: Date(),
                condition: "Excellent",
                usageHours: i * 50,
                referenceCode: "TOOL\(i)",
                notes: "Calibrate regularly",
                createdDate: Date(),
                updatedDate: Date(),
                purchaseCost: Double(i) * 100,
                supplier: "Supplier \(i)",
                inspectionDate: Date(),
                calibrationDate: Date(),
                safetyCertificate: "Safe\(i)",
                insuranceDetails: "Ins\(i)",
                tags: ["Essential"],
                supervisor: "Supervisor \(i)",
                department: "Dept \(i)",
                availabilityStatus: "Available",
                reservedForJob: nil,
                disposalDate: nil,
                recycled: false,
                depreciationRate: 5.0,
                currency: "USD",
                archived: false
            )
        }
        
        estimates = (1...5).map { i in
            Estimate(
                jobID: jobListings.randomElement()!.id,
                clientID: clients.randomElement()!.id,
                issueDate: Date(),
                validUntil: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
                status: "Draft",
                totalCost: Double(i) * 1000,
                laborCost: Double(i) * 300,
                materialCost: Double(i) * 500,
                toolCost: Double(i) * 200,
                taxAmount: 100.0,
                discount: 50.0,
                grandTotal: Double(i) * 1200,
                notes: "Estimate notes",
                currency: "USD",
                version: 1,
                referenceCode: "EST\(i)",
                preparedBy: "Staff \(i)",
                approvedBy: "Manager \(i)",
                approvalStatus: "Pending",
                createdDate: Date(),
                updatedDate: Date(),
                revisionNotes: "None",
                validityPeriod: 30,
                paymentTerms: "30 days",
                warrantyTerms: "1 year",
                deliverySchedule: "Within 2 weeks",
                riskAssessment: "Low",
                complianceNotes: "Compliant",
                legalClauses: "Standard terms",
                insuranceDetails: "Ins\(i)",
                specialDiscountReason: "Promo",
                extraCharges: 0.0,
                supervisor: "Supervisor \(i)",
                tags: ["Estimate"],
                archived: false
            )
        }
        
        auditEntries = (1...10).map { i in
            AuditEntry(
                entityType: "Job",
                entityID: jobListings.randomElement()!.id,
                action: "Created",
                performedBy: "Admin",
                timestamp: Date(),
                reason: "New entry",
                oldValue: "",
                newValue: "Job \(i)",
                device: "iPhone",
                ipAddress: "192.168.1.\(i)",
                location: "Office",
                sessionID: "SESSION\(i)",
                appVersion: "1.0",
                osVersion: "iOS 14",
                referenceCode: "AUDIT\(i)",
                createdDate: Date(),
                updatedDate: Date(),
                approvalStatus: "Approved",
                approvedBy: "Supervisor",
                rejectionReason: "",
                tags: ["System"],
                relatedJobID: jobListings.randomElement()!.id,
                relatedClientID: clients.randomElement()!.id,
                relatedToolID: tools.randomElement()?.id,
                relatedMaterialID: materials.randomElement()?.id,
                supervisor: "Supervisor \(i)",
                department: "Dept \(i)",
                archived: false,
                notes: "Audit note",
                severity: "Low",
                complianceStatus: "OK",
                correctiveAction: "None",
                followUpDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
            )
        }
        
        saveAll()
    }
}
