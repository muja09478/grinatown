import SwiftUI
import Foundation


@available(iOS 14.0, *)
struct ClientTheme {
    static let bg = Color("ClientBG").opacity(0.95) // Define in Assets or fall back to system
    static let card = Color(.secondarySystemBackground)
    static let primary = Color(red: 0.13, green: 0.60, blue: 0.95) // azure
    static let accentA = Color(red: 0.98, green: 0.58, blue: 0.19) // orange
    static let accentB = Color(red: 0.16, green: 0.80, blue: 0.54) // teal
    static let danger = Color(red: 0.90, green: 0.11, blue: 0.32) // red
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    static func gradient(_ a: Color = primary, _ b: Color = accentB) -> LinearGradient {
        LinearGradient(gradient: Gradient(colors: [a, b]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    static func fieldIconBG(_ color: Color) -> some View {
        Circle().fill(color.opacity(0.15))
    }
}
@available(iOS 14.0, *)
struct ClientAddSectionHeaderView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let accent: Color

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            ZStack {
                ClientTheme.fieldIconBG(accent)
                    .frame(width: 36, height: 36)
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(ClientTheme.textPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(ClientTheme.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

@available(iOS 14.0, *)
struct ClientAddFieldView: View {
    let label: String
    let placeholder: String
    let systemImage: String
    let accent: Color
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var autocap: UITextAutocapitalizationType = .sentences

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(ClientTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(text.isEmpty ? Color.gray.opacity(0.2) : accent.opacity(0.5), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    ZStack {
                        ClientTheme.fieldIconBG(accent)
                            .frame(width: 30, height: 30)
                        Image(systemName: systemImage)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(accent)
                    }
                    Text(label)
                        .font(.footnote)
                        .foregroundColor(text.isEmpty ? .secondary : accent)
                    Spacer()
                }
                .padding(.top, 10)

                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(autocap)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground))
                    )
            }
            .padding(12)
        }
        .accessibilityElement(children: .combine)
    }
}

@available(iOS 14.0, *)
struct ClientAddDatePickerView: View {
    let label: String
    let systemImage: String
    let accent: Color
    @Binding var date: Date
    var includesTime: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(ClientTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(accent.opacity(0.4), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    ZStack {
                        ClientTheme.fieldIconBG(accent)
                            .frame(width: 30, height: 30)
                        Image(systemName: systemImage)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(accent)
                    }
                    Text(label)
                        .font(.footnote)
                        .foregroundColor(accent)
                    Spacer()
                }
                .padding(.top, 10)

                DatePicker("", selection: $date, displayedComponents: includesTime ? [.date, .hourAndMinute] : [.date])
                    .labelsHidden()
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground))
                    )
            }
            .padding(12)
        }
    }
}

@available(iOS 14.0, *)
struct ClientToggleRowView: View {
    let label: String
    let systemImage: String
    let accent: Color
    @Binding var isOn: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(ClientTheme.card)
            HStack(spacing: 12) {
                ZStack {
                    ClientTheme.fieldIconBG(accent).frame(width: 30, height: 30)
                    Image(systemName: systemImage)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(accent)
                }
                Text(label)
                    .font(.body)
                    .foregroundColor(ClientTheme.textPrimary)
                Spacer()
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            .padding(12)
        }
    }
}

@available(iOS 14.0, *)
struct ClientSearchBarView: View {
    @Binding var text: String
    @State private var isEditing: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(isEditing ? ClientTheme.primary : .secondary)
                    .scaleEffect(isEditing ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2))
                TextField("Search clients, companies, regions...", text: $text, onEditingChanged: { editing in
                    withAnimation { isEditing = editing }
                })
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.words)
                if !text.isEmpty {
                    Button(action: { withAnimation { text = "" } }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .accessibility(label: Text("Search clients"))
    }
}

@available(iOS 14.0, *)
struct ClientListRowView: View {
    let client: Client

    var ratingStars: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { idx in
                Image(systemName: idx < client.rating ? "star.fill" : "star")
                    .font(.system(size: 12))
                    .foregroundColor(idx < client.rating ? ClientTheme.accentA : .gray.opacity(0.4))
            }
        }
    }

    var tagsView: some View {
        HStack(spacing: 6) {
            ForEach(Array(client.tags.prefix(4)), id: \.self) { tag in
                Text(tag)
                    .font(.caption2)
                    .foregroundColor(ClientTheme.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 8).fill(ClientTheme.primary.opacity(0.12)))
            }
            if client.tags.count > 4 {
                Text("+\(client.tags.count - 4)")
                    .font(.caption2).foregroundColor(.secondary)
                    .padding(.horizontal, 6).padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2)))
            }
        }
    }

    var statusBadges: some View {
        HStack(spacing: 8) {
            badge(text: client.clientType, color: ClientTheme.accentB)
            if client.vip {
                badge(text: "VIP", color: ClientTheme.accentA)
            }
            if client.archived {
                badge(text: "Archived", color: ClientTheme.danger)
            }
        }
    }

    func badge(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2).bold()
            .foregroundColor(color)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 8).fill(color.opacity(0.12)))
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ClientTheme.card)
                .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    ZStack {
                        ClientTheme.gradient(ClientTheme.primary, ClientTheme.accentB)
                            .mask(Circle())
                            .frame(width: 42, height: 42)
                            .opacity(0.25)
                        Image(systemName: client.vip ? "crown.fill" : "person.crop.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(client.vip ? ClientTheme.accentA : ClientTheme.primary)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(client.name)
                            .font(.headline)
                            .foregroundColor(ClientTheme.textPrimary)
                            .lineLimit(1)
                        Text(client.company)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    ratingStars
                }

                Divider().opacity(0.15)

                HStack(spacing: 12) {
                    rowIconText("phone.fill", client.contactNumber, ClientTheme.accentB)
                    rowIconText("envelope.fill", client.email, ClientTheme.accentA)
                }

                HStack(spacing: 12) {
                    rowIconText("mappin.and.ellipse", client.region, ClientTheme.primary)
                    rowIconText("globe", client.preferredLanguage, ClientTheme.accentB)
                }

                statusBadges
                tagsView
            }
            .padding(14)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    func rowIconText(_ icon: String, _ text: String, _ color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(color)
            Text(text).font(.caption).foregroundColor(.secondary).lineLimit(1)
        }
    }
}

@available(iOS 14.0, *)
struct ClientNoDataView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                ClientTheme.gradient(ClientTheme.primary, ClientTheme.accentA)
                    .mask(Circle())
                    .frame(width: 120, height: 120)
                    .opacity(0.18)
                Image(systemName: "person.3.sequence.fill")
                    .font(.system(size: 54))
                    .foregroundColor(ClientTheme.primary)
                    .shadow(color: ClientTheme.primary.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            Text("No Clients Yet")
                .font(.title3).bold()
                .foregroundColor(ClientTheme.textPrimary)
            Text("Tap the + button to add your first client. Keep your contacts organized, searchable, and rich with details.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.vertical, 40)
    }
}
@available(iOS 14.0, *)
struct ClientDetailFieldRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                ClientTheme.fieldIconBG(color).frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption).foregroundColor(.secondary)
                Text(value).font(.body).foregroundColor(ClientTheme.textPrimary)
            }
            Spacer()
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

@available(iOS 14.0, *)
struct ClientAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var data: CarpenterDataManager

    @State private var name = ""
    @State private var contactNumber = ""
    @State private var email = ""
    @State private var address = ""
    @State private var company = ""
    @State private var preferredPaymentMethod = ""
    @State private var clientType = "Regular"
    @State private var notes = ""
    @State private var createdDate = Date()
    @State private var updatedDate = Date()
    @State private var loyaltyLevel = "Bronze"
    @State private var totalJobs = 0
    @State private var completedJobs = 0
    @State private var pendingJobs = 0
    @State private var cancelledJobs = 0
    @State private var outstandingBalance = ""
    @State private var lastPaymentDate = Date()
    @State private var hasLastPayment = false
    @State private var preferredContactTime = "Anytime"
    @State private var referenceCode = ""
    @State private var rating = 3
    @State private var feedback = ""
    @State private var taxID = ""
    @State private var billingAddress = ""
    @State private var shippingAddress = ""
    @State private var alternatePhone = ""
    @State private var emergencyContact = ""
    @State private var socialMediaHandle = ""
    @State private var preferredLanguage = "English"
    @State private var region = ""
    @State private var zipCode = ""
    @State private var vip = false
    @State private var accountManager = ""
    @State private var tagsText = "Loyal, Priority"
    @State private var archived = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    let clientTypes = ["Regular", "Enterprise", "One-time", "Reseller"]
    let loyaltyLevels = ["Bronze", "Silver", "Gold", "Platinum"]
    let contactTimes = ["Morning", "Afternoon", "Evening", "Anytime"]
    let languages = ["English", "Spanish", "French", "German", "Arabic", "Chinese", "Hindi"]

    var body: some View {
        NavigationView {
            ScrollView {
                // Identity
                ClientAddSectionHeaderView(
                    title: "Identity",
                    subtitle: "Basic required details",
                    systemImage: "person.crop.circle.badge.checkmark",
                    accent: ClientTheme.primary
                )
                VStack(spacing: 12) {
                    ClientAddFieldView(label: "Name", placeholder: "Jane Appleseed", systemImage: "person.fill", accent: ClientTheme.primary, text: $name, autocap: .words)
                    ClientAddFieldView(label: "Company", placeholder: "Acme Inc.", systemImage: "building.2.fill", accent: ClientTheme.primary, text: $company, autocap: .words)
                    ClientAddFieldView(label: "Reference Code", placeholder: "CL-2025-0001", systemImage: "number.circle.fill", accent: ClientTheme.primary, text: $referenceCode, autocap: .allCharacters)
                }
                .padding(.horizontal)

                // Contact
                ClientAddSectionHeaderView(
                    title: "Contact",
                    subtitle: "Reach and addresses",
                    systemImage: "phone.bubble.fill",
                    accent: ClientTheme.accentB
                )
                VStack(spacing: 12) {
                    ClientAddFieldView(label: "Contact Number", placeholder: "+1 555 123 4567", systemImage: "phone.fill", accent: ClientTheme.accentB, text: $contactNumber, keyboard: .phonePad)
                    ClientAddFieldView(label: "Alternate Phone", placeholder: "+1 555 987 6543", systemImage: "phone.connection.fill", accent: ClientTheme.accentB, text: $alternatePhone, keyboard: .phonePad)
                    ClientAddFieldView(label: "Email", placeholder: "client@company.com", systemImage: "envelope.fill", accent: ClientTheme.accentB, text: $email, keyboard: .emailAddress, autocap: .none)
                    ClientAddFieldView(label: "Billing Address", placeholder: "123 Main St, City", systemImage: "creditcard.fill", accent: ClientTheme.accentB, text: $billingAddress)
                    ClientAddFieldView(label: "Shipping Address", placeholder: "Warehouse 9, City", systemImage: "shippingbox.fill", accent: ClientTheme.accentB, text: $shippingAddress)
                    ClientAddFieldView(label: "Address (General)", placeholder: "HQ address or primary site", systemImage: "mappin.and.ellipse", accent: ClientTheme.accentB, text: $address)
                    ClientAddFieldView(label: "Region", placeholder: "EMEA / APAC / NA", systemImage: "globe", accent: ClientTheme.accentB, text: $region)
                    ClientAddFieldView(label: "ZIP/Postal Code", placeholder: "90210", systemImage: "mail.and.text.magnifyingglass", accent: ClientTheme.accentB, text: $zipCode, keyboard: .numbersAndPunctuation)
                    ClientAddFieldView(label: "Emergency Contact", placeholder: "Name and number", systemImage: "exclamationmark.bubble.fill", accent: ClientTheme.accentB, text: $emergencyContact)
                    ClientAddFieldView(label: "Social Handle", placeholder: "@client", systemImage: "at.circle.fill", accent: ClientTheme.accentB, text: $socialMediaHandle, autocap: .none)
                }
                .padding(.horizontal)

                // Preferences
                ClientAddSectionHeaderView(
                    title: "Preferences",
                    subtitle: "Payment, language & timing",
                    systemImage: "slider.horizontal.3",
                    accent: ClientTheme.accentA
                )
                VStack(spacing: 12) {
                    // Pickers styled as cards
                    cardPicker(title: "Client Type", icon: "person.2.fill", accent: ClientTheme.accentA, selection: $clientType, options: clientTypes)
                    cardPicker(title: "Loyalty Level", icon: "rosette", accent: ClientTheme.accentA, selection: $loyaltyLevel, options: loyaltyLevels)
                    cardPicker(title: "Preferred Contact Time", icon: "clock.fill", accent: ClientTheme.accentA, selection: $preferredContactTime, options: contactTimes)
                    cardPicker(title: "Language", icon: "character.book.closed.fill", accent: ClientTheme.accentA, selection: $preferredLanguage, options: languages)

                    ClientAddFieldView(label: "Preferred Payment Method", placeholder: "Card / Wire / Cash", systemImage: "banknote.fill", accent: ClientTheme.accentA, text: $preferredPaymentMethod)
                    ClientToggleRowView(label: "VIP Client", systemImage: "crown.fill", accent: ClientTheme.accentA, isOn: $vip)
                    ClientToggleRowView(label: "Archived", systemImage: "archivebox.fill", accent: ClientTheme.danger, isOn: $archived)
                    HStack {
                        Text("Rating")
                            .font(.footnote).foregroundColor(.secondary)
                        Spacer()
                        Stepper(value: $rating, in: 1...5) {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { i in
                                    Image(systemName: i < rating ? "star.fill" : "star")
                                        .foregroundColor(ClientTheme.accentA)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(ClientTheme.card))
                }
                .padding(.horizontal)

                // Business Stats
                ClientAddSectionHeaderView(
                    title: "Business",
                    subtitle: "Stats & financials",
                    systemImage: "chart.bar.fill",
                    accent: ClientTheme.primary
                )
                VStack(spacing: 12) {
                    counterRow(title: "Total Jobs", value: $totalJobs, color: ClientTheme.primary)
                    counterRow(title: "Completed Jobs", value: $completedJobs, color: ClientTheme.accentB)
                    counterRow(title: "Pending Jobs", value: $pendingJobs, color: ClientTheme.accentA)
                    counterRow(title: "Cancelled Jobs", value: $cancelledJobs, color: ClientTheme.danger)

                    ClientAddFieldView(label: "Outstanding Balance", placeholder: "e.g., 1250.00", systemImage: "dollarsign.circle.fill", accent: ClientTheme.primary, text: $outstandingBalance, keyboard: .decimalPad)

                    // Last payment
                    ZStack {
                        RoundedRectangle(cornerRadius: 14).fill(ClientTheme.card)
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle(isOn: $hasLastPayment) {
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                        .foregroundColor(ClientTheme.primary)
                                    Text("Include Last Payment Date")
                                }
                            }.toggleStyle(SwitchToggleStyle(tint: ClientTheme.primary))
                            if hasLastPayment {
                                ClientAddDatePickerView(label: "Last Payment Date", systemImage: "calendar", accent: ClientTheme.primary, date: $lastPaymentDate)
                            }
                        }
                        .padding(12)
                    }

                    ClientAddFieldView(label: "Tax ID", placeholder: "TAX-XXXXX", systemImage: "doc.text.fill", accent: ClientTheme.primary, text: $taxID, autocap: .allCharacters)
                    ClientAddFieldView(label: "Account Manager", placeholder: "Manager name", systemImage: "person.fill.badge.plus", accent: ClientTheme.primary, text: $accountManager)
                    ClientAddFieldView(label: "Tags (comma separated)", placeholder: "Loyal, Priority, Wholesale", systemImage: "tag.fill", accent: ClientTheme.primary, text: $tagsText, autocap: .none)
                }
                .padding(.horizontal)

                // Notes & Meta
                ClientAddSectionHeaderView(
                    title: "Notes & Meta",
                    subtitle: "Feedback and system fields",
                    systemImage: "note.text",
                    accent: ClientTheme.accentB
                )
                VStack(spacing: 12) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14).fill(ClientTheme.card)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 10) {
                                ZStack {
                                    ClientTheme.fieldIconBG(ClientTheme.accentB).frame(width: 30, height: 30)
                                    Image(systemName: "bubble.left.and.bubble.right.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(ClientTheme.accentB)
                                }
                                Text("Feedback & Notes")
                                    .font(.footnote)
                                    .foregroundColor(ClientTheme.accentB)
                                Spacer()
                            }
                            TextEditor(text: $feedback)
                                .frame(minHeight: 90)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
                            TextEditor(text: $notes)
                                .frame(minHeight: 90)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
                        }
                        .padding(12)
                    }

                    HStack(spacing: 12) {
                        ClientAddDatePickerView(label: "Created Date", systemImage: "calendar", accent: ClientTheme.accentB, date: $createdDate)
                        ClientAddDatePickerView(label: "Updated Date", systemImage: "calendar.badge.exclamationmark", accent: ClientTheme.accentB, date: $updatedDate)
                    }
                }
                .padding(.horizontal)

                // Save Button
                Button(action: saveClient) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Client")
                            .bold()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 14).fill(ClientTheme.gradient(ClientTheme.primary, ClientTheme.accentA)))
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                    .accessibility(label: Text("Save client"))
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitle("Add Client", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Client Form"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK"), action: {
                        if alertMessage.contains("saved successfully") {
                            presentationMode.wrappedValue.dismiss()
                        }
                      }))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // Helpers

    func cardPicker(title: String, icon: String, accent: Color, selection: Binding<String>, options: [String]) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 14).fill(ClientTheme.card)
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    ZStack {
                        ClientTheme.fieldIconBG(accent).frame(width: 30, height: 30)
                        Image(systemName: icon).font(.system(size: 14, weight: .semibold)).foregroundColor(accent)
                    }
                    Text(title).font(.footnote).foregroundColor(accent)
                    Spacer()
                }
                Picker("", selection: selection) {
                    ForEach(options, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(MenuPickerStyle()) // iOS 14 compatible
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
            }
            .padding(12)
        }
    }

    func counterRow(title: String, value: Binding<Int>, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).fill(ClientTheme.card)
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        ClientTheme.fieldIconBG(color).frame(width: 30, height: 30)
                        Image(systemName: "number.circle.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(color)
                    }
                    Text(title).font(.body).foregroundColor(ClientTheme.textPrimary)
                }
                Spacer()
                Stepper(value: value, in: 0...100000) {
                    Text("\(value.wrappedValue)")
                        .font(.body).foregroundColor(ClientTheme.textPrimary)
                        .frame(minWidth: 44, alignment: .trailing)
                }
            }
            .padding(12)
        }
    }

    func saveClient() {
        var errors: [String] = []

        // Required checks
        if name.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Name is required.") }
        if company.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Company is required.") }
        if referenceCode.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Reference Code is required.") }
        if contactNumber.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Contact Number is required.") }
        if email.trimmingCharacters(in: .whitespaces).isEmpty || !email.contains("@") { errors.append("Valid Email is required.") }
        if billingAddress.isEmpty { errors.append("Billing Address is required.") }
        if shippingAddress.isEmpty { errors.append("Shipping Address is required.") }
        if address.isEmpty { errors.append("General Address is required.") }
        if region.isEmpty { errors.append("Region is required.") }
        if zipCode.isEmpty { errors.append("ZIP/Postal code is required.") }
        if preferredPaymentMethod.isEmpty { errors.append("Preferred Payment Method is required.") }
        if accountManager.isEmpty { errors.append("Account Manager is required.") }
        if taxID.isEmpty { errors.append("Tax ID is required.") }

        // Numeric validation
        let balance = Double(outstandingBalance) ?? -1
        if outstandingBalance.isEmpty || balance < 0 {
            errors.append("Outstanding Balance must be a non-negative number.")
        }
        if completedJobs > totalJobs { errors.append("Completed Jobs cannot exceed Total Jobs.") }
        if pendingJobs + completedJobs + cancelledJobs > totalJobs {
            errors.append("Sum of Completed, Pending, and Cancelled cannot exceed Total Jobs.")
        }

        if !errors.isEmpty {
            alertMessage = errors.joined(separator: "\n• ")
            showAlert = true
            return
        }

        let tags = tagsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let client = Client(
            name: name,
            contactNumber: contactNumber,
            email: email,
            address: address,
            company: company,
            preferredPaymentMethod: preferredPaymentMethod,
            clientType: clientType,
            notes: notes,
            createdDate: createdDate,
            updatedDate: updatedDate,
            loyaltyLevel: loyaltyLevel,
            totalJobs: totalJobs,
            completedJobs: completedJobs,
            pendingJobs: pendingJobs,
            cancelledJobs: cancelledJobs,
            outstandingBalance: balance,
            lastPaymentDate: hasLastPayment ? lastPaymentDate : nil,
            preferredContactTime: preferredContactTime,
            referenceCode: referenceCode,
            rating: rating,
            feedback: feedback,
            taxID: taxID,
            billingAddress: billingAddress,
            shippingAddress: shippingAddress,
            alternatePhone: alternatePhone,
            emergencyContact: emergencyContact,
            socialMediaHandle: socialMediaHandle,
            preferredLanguage: preferredLanguage,
            region: region,
            zipCode: zipCode,
            vip: vip,
            accountManager: accountManager,
            tags: tags,
            archived: archived
        )

        data.addClient(client)
        alertMessage = "Client saved successfully."
        showAlert = true
    }
}

@available(iOS 14.0, *)
struct ClientListView: View {
    @ObservedObject var data: CarpenterDataManager
    @State private var searchText: String = ""
    @State private var showAdd: Bool = false

    var filtered: [Client] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return data.clients.sorted { $0.name < $1.name }
        }
        let q = searchText.lowercased()
        return data.clients.filter { c in
            [
                c.name, c.company, c.region, c.email, c.contactNumber, c.accountManager,
                c.preferredLanguage, c.clientType, c.referenceCode, c.zipCode
            ].map { $0.lowercased() }
            .contains(where: { $0.contains(q) }) ||
            c.tags.joined(separator: ",").lowercased().contains(q)
        }.sorted { $0.name < $1.name }
    }

    var body: some View {
            VStack(spacing: 0) {
                ClientSearchBarView(text: $searchText)
                if filtered.isEmpty {
                    ClientNoDataView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGroupedBackground))
                } else {
                    List {
                        ForEach(filtered, id: \.id) { client in
                            NavigationLink(destination: ClientDetailView(client: client, data: data)) {
                                ClientListRowView(client: client)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Clients", displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: { showAdd = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(ClientTheme.primary)
                        .accessibility(label: Text("Add Client"))
                }
            )
            .sheet(isPresented: $showAdd, content: {
                ClientAddView(data: data)
            })
        
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func delete(at offsets: IndexSet) {
        // Map offsets from filtered -> original data index
        let ids = offsets.map { filtered[$0].id }
        if let firstIndex = data.clients.firstIndex(where: { $0.id == ids.first }) {
            data.deleteClient(at: IndexSet(integer: firstIndex))
        }
    }
}
@available(iOS 14.0, *)
struct ClientDetailView: View {
    let client: Client
    @ObservedObject var data: CarpenterDataManager

    var header: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 20).fill(ClientTheme.gradient(ClientTheme.primary, ClientTheme.accentB))
                .frame(height: 160)
            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    Circle().fill(Color.white.opacity(0.18)).frame(width: 70, height: 70)
                    Image(systemName: client.vip ? "crown.fill" : "person.crop.circle.fill")
                        .font(.system(size: 44)).foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(client.name).font(.title2).bold().foregroundColor(.white).lineLimit(1)
                    Text(client.company).font(.subheadline).foregroundColor(Color.white.opacity(0.9)).lineLimit(1)
                    HStack(spacing: 6) {
                        ForEach(0..<5) { idx in
                            Image(systemName: idx < client.rating ? "star.fill" : "star")
                                .foregroundColor(Color.yellow.opacity(0.9))
                                .font(.system(size: 12))
                        }
                    }
                }
                Spacer()
            }
            .padding(16)
        }
        .padding(.horizontal)
    }

    func block(title: String, icon: String, color: Color, content: AnyView) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    ClientTheme.fieldIconBG(color).frame(width: 30, height: 30)
                    Image(systemName: icon).foregroundColor(color).font(.system(size: 14, weight: .semibold))
                }
                Text(title).font(.headline).foregroundColor(ClientTheme.textPrimary)
                Spacer()
            }
            content
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(ClientTheme.card))
        .padding(.horizontal)
    }

    var body: some View {
        ScrollView {
            header

            // Contact & Identity
            block(
                title: "Identity & Contact",
                icon: "person.fill",
                color: ClientTheme.primary,
                content: AnyView(VStack(spacing: 8) {
                    ClientDetailFieldRow(icon: "person.fill", label: "Name", value: client.name, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "building.2.fill", label: "Company", value: client.company, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "number.circle", label: "Reference Code", value: client.referenceCode, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "phone.fill", label: "Primary Phone", value: client.contactNumber, color: ClientTheme.primary)
                    if !client.alternatePhone.isEmpty {
                        ClientDetailFieldRow(icon: "phone.connection.fill", label: "Alternate Phone", value: client.alternatePhone, color: ClientTheme.primary)
                    }
                    ClientDetailFieldRow(icon: "envelope.fill", label: "Email", value: client.email, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "mappin.and.ellipse", label: "Address", value: client.address, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "creditcard.fill", label: "Billing Address", value: client.billingAddress, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "shippingbox.fill", label: "Shipping Address", value: client.shippingAddress, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "globe", label: "Region", value: client.region, color: ClientTheme.primary)
                    ClientDetailFieldRow(icon: "mail.and.text.magnifyingglass", label: "ZIP", value: client.zipCode, color: ClientTheme.primary)
                })
            )

            block(
                title: "Preferences",
                icon: "slider.horizontal.3",
                color: ClientTheme.accentA,
                content: AnyView(VGridTwoColumn(spacing: 8, items: [
                    ("Client Type", client.clientType, "person.2.fill"),
                    ("Loyalty Level", client.loyaltyLevel, "rosette"),
                    ("Preferred Contact Time", client.preferredContactTime, "clock.fill"),
                    ("Language", client.preferredLanguage, "character.book.closed.fill"),
                    ("Payment Method", client.preferredPaymentMethod, "banknote.fill"),
                    ("VIP", client.vip ? "Yes" : "No", "crown.fill"),
                    ("Archived", client.archived ? "Yes" : "No", "archivebox.fill"),
                    ("Account Manager", client.accountManager, "person.fill.badge.plus"),
                    ("Tax ID", client.taxID, "doc.text.fill")
                ], color: ClientTheme.accentA))
            )

            block(
                title: "Business & Financials",
                icon: "chart.bar.fill",
                color: ClientTheme.accentB,
                content: AnyView(VStack(spacing: 8) {
                    VGridTwoColumn(spacing: 8, items: [
                        ("Total Jobs", String(client.totalJobs), "number.circle.fill"),
                        ("Completed", String(client.completedJobs), "checkmark.circle.fill"),
                        ("Pending", String(client.pendingJobs), "clock.badge.exclamationmark.fill"),
                        ("Cancelled", String(client.cancelledJobs), "xmark.circle.fill"),
                        ("Outstanding Balance", String(format: "%.2f", client.outstandingBalance), "dollarsign.circle.fill")
                    ], color: ClientTheme.accentB)
                    if let lastPay = client.lastPaymentDate {
                        ClientDetailFieldRow(icon: "calendar.badge.clock", label: "Last Payment", value: DateFormatter.localizedString(from: lastPay, dateStyle: .medium, timeStyle: .none), color: ClientTheme.accentB)
                    }
                })
            )

            block(
                title: "Social & Emergency",
                icon: "exclamationmark.bubble.fill",
                color: ClientTheme.danger,
                content: AnyView(VGridTwoColumn(spacing: 8, items: [
                    ("Emergency Contact", client.emergencyContact, "exclamationmark.triangle.fill"),
                    ("Social Handle", client.socialMediaHandle, "at.circle.fill")
                ], color: ClientTheme.danger))
            )

            // Tags
            if !client.tags.isEmpty {
                block(
                    title: "Tags",
                    icon: "tag.fill",
                    color: ClientTheme.primary,
                    content: AnyView(
                        FlexibleTagList(tags: client.tags, color: ClientTheme.primary)
                            .padding(.top, 6)
                    )
                )
            }

            block(
                title: "Feedback & Notes",
                icon: "note.text",
                color: ClientTheme.accentA,
                content: AnyView(VStack(spacing: 8) {
                    if !client.feedback.isEmpty {
                        ClientDetailFieldRow(icon: "bubble.left.and.bubble.right.fill", label: "Feedback", value: client.feedback, color: ClientTheme.accentA)
                    }
                    if !client.notes.isEmpty {
                        ClientDetailFieldRow(icon: "note.text", label: "Notes", value: client.notes, color: ClientTheme.accentA)
                    }
                })
            )

            block(
                title: "Timestamps",
                icon: "calendar",
                color: ClientTheme.primary,
                content: AnyView(VGridTwoColumn(spacing: 8, items: [
                    ("Created", DateFormatter.localizedString(from: client.createdDate, dateStyle: .medium, timeStyle: .none), "calendar"),
                    ("Updated", DateFormatter.localizedString(from: client.updatedDate, dateStyle: .medium, timeStyle: .none), "calendar.badge.exclamationmark")
                ], color: ClientTheme.primary))
            )

            Spacer(minLength: 24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitle("Client Details", displayMode: .inline)
    }
}

@available(iOS 14.0, *)
struct VGridTwoColumn: View {
    let spacing: CGFloat
    let items: [(String, String, String)]
    let color: Color

    var columns: [GridItem] { [GridItem(.flexible(), spacing: spacing), GridItem(.flexible(), spacing: spacing)] }

    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(0..<items.count, id: \.self) { idx in
                let item = items[idx]
                ClientDetailFieldRow(icon: item.2, label: item.0, value: item.1, color: color)
            }
        }
    }
}

@available(iOS 14.0, *)
struct FlexibleTagList: View {
    let tags: [String]
    let color: Color

    var body: some View {
        WrapHStack(spacing: 8, lineSpacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption).bold()
                    .foregroundColor(color)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 10).fill(color.opacity(0.12)))
            }
        }
    }
}

@available(iOS 14.0, *)
struct WrapHStack<Content: View>: View {
    let spacing: CGFloat
    let lineSpacing: CGFloat
    let content: () -> Content

    init(spacing: CGFloat = 8, lineSpacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            self.generateContent(in: geo)
        }
        .frame(minHeight: 0)
    }

    func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            content()
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width) {
                        width = 0
                        height -= d.height + lineSpacing
                    }
                    let result = width
                    if idxHack { width = 0 } // no-op; placeholder
                    width -= d.width + spacing
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = height
                    if idxHack { height = 0 } // no-op; placeholder
                    return result
                })
        }
    }

  
    var idxHack: Bool { false }
}

