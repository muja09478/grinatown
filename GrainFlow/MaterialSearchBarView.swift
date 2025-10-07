import SwiftUI

@available(iOS 14.0, *)
struct MaterialSearchBarView: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(MaterialTheme.textSecondary)
                TextField("Search materials by name, category, supplier, or tag", text: $text, onEditingChanged: { editing in
                    withAnimation(.spring()) { isEditing = editing }
                })
                .foregroundColor(MaterialTheme.textPrimary)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(MaterialTheme.textSecondary)
                    }
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.6))
            .cornerRadius(12)
            
            if isEditing {
                Button("Cancel") {
                    withAnimation(.spring()) {
                        text = ""
                        isEditing = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .foregroundColor(MaterialTheme.accent)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}
