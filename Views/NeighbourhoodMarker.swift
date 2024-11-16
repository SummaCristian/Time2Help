import SwiftUI

struct NeighbourhoodMarker: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isSelected: Bool
    let neighbourhood: Neighbourhood
    
    // The UI
    var body: some View {
        VStack(spacing: 10) {
            Text("Q")
                .font(.custom("Futura-bold", size: 25))
                .foregroundStyle(isSelected ? .white : .orange)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isSelected ? LinearGradient(colors: [.orange], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray4), Color(.systemGray5)] : [Color(.systemGray6), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .primary.opacity(0.2), radius: 6)
                        .padding(.all, isSelected ? -4 : 0)
                        .overlay {
                            RoundedRectangle(cornerRadius: isSelected ? 8 : 12)
                                .stroke(isSelected ? LinearGradient(colors: [.white], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray3), Color(.systemGray5)] : [Color(.white), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        }
                )
            
            Text(neighbourhood.name)
                .font(.subheadline.bold())
        }
    }
}
